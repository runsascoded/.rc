import scala.xml.{Node, XML}

case class Module(group: String,
                  artifact: String,
                  versionOpt: Option[String] = None,
                  typeOpt: Option[String] = None,
                  scopeOpt: Option[String] = None,
                  autoScalaVersion: Boolean = false,
                  exclusions: Seq[Module] = Nil) {
  override def toString: String = {
    val artifactOp = if (autoScalaVersion) "%%" else "%"
    val exclusionsStr =
      exclusions
        .map {
          case Module(group, artifact, _, _, _, _, _) =>
            s""" exclude(\"$group\", \"$artifact\")"""
        }
        .mkString("")

    val versionStr = versionOpt.map(version => s""" % \"$version\"""").getOrElse("")

    val scopeStr = scopeOpt.map(scope => s""" % \"$scope\"""").getOrElse("")

    s"""\"$group\" $artifactOp \"$artifact\"$versionStr$scopeStr$exclusionsStr"""
  }
}

object Module {

  val scalaVersionRegex = """_(2.10|2.11|\$\{scala\.version\.prefix\})$""".r
  val propVersionRegex = """^\$\{([^}]+)\}$""".r

  def parse(dep: Node, propsMap: Map[String, String] = Map.empty): Module = {
    val group = dep \ "groupId" text
    var artifact = dep \ "artifactId" text
    var autoScalaVersion = false
    val versionOpt =
      (dep \ "version").text match {
        case propVersionRegex(key) => Some(propsMap.getOrElse(key, key))
        case "" => None
        case v => Some(v)
      }

    artifact =
      scalaVersionRegex.findFirstIn(artifact) match {
        case Some(m) =>
          autoScalaVersion = true
          artifact.dropRight(m.length)
        case None => artifact
      }

    val exclusions =
      dep \ "exclusions" \ "exclusion" map { exclusion =>
        parse(exclusion, propsMap)
      }

    val typeOpt = {
      val tpe = (dep \ "type" text)
      if (tpe.isEmpty)
        None
      else
        Some(tpe)
    }

    val scopeOpt = {
      val scope = (dep \ "scope" text)
      if (scope.isEmpty)
        None
      else
        Some(scope)
    }

    Module(group, artifact, versionOpt, typeOpt, scopeOpt, autoScalaVersion, exclusions)
  }
}

object POMToSBT {
  def main(args: Array[String]): Unit = {
    val xml = XML.loadFile(args(0))

    val project = xml \\ "project"

    val properties = project \ "properties"
    val propsMap = properties \ "_" map(prop => prop.label -> prop.text) toMap

    val dependencies = project \ "dependencies" \ "dependency"

    dependencies.foreach(dep => {
      println(Module.parse(dep, propsMap) + ",")
    })
  }
}

POMToSBT.main(args)
