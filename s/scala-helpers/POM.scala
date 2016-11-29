
object POM {
  import scala.collection.mutable.ArrayBuffer
  import scala.xml.XML
  def main(args: Array[String]): Unit = {
    val xml = XML.loadFile(args(0))
    val dependencies = xml \\ "project" \ "dependencies" \ "dependency"
    println(s"Found ${dependencies.length} dependencies")

    val scalaVersionRegex = """_(2.10|2.11|\$\{scala\.version\.prefix\})""".r

    dependencies.foreach(dep => {
      val group = dep \ "groupId" text
      var artifact = dep \ "artifactId" text
      var artifactOp = "%"
      val version = dep \ "version" text
        artifact =
        scalaVersionRegex.findFirstIn(artifact) match {
          case Some(m) =>
            artifactOp = "%%"
            artifact.dropRight(m.length)
          case None => artifact
        }

      println(s"\"${group}\" $artifactOp \"$artifact\" % \"$version\"")
    })
  }
}

POM(args)
