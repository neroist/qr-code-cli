import qr
import os
import uri
import cligen
import strutils
import strformat

proc main(
  content: string,
  filename = "",
  filetype = "png",
  fgColor = "000000",
  bgColor = "ffffff";
  size: int = 200) =
  if filetype.toLowerAscii() notin qr.Filetypes:
    stderr.write(fmt"Invalid filetype. Must be one of {qr.Filetypes}")
    return # exit function/cli

  if size notin 10..1000:
    stderr.write("Size out of range.\n")
    return

  var filename = filename

  if filename == "":
    filename = parseUri(content).hostname

    if filename == "":
      filename = content

  echo "Creating your QR code..." # loading message

  qrCode(
    data=content,
    filename=filename,
    filetype=filetype,
    bgColor=bgColor,
    fgColor=fgColor,
    size=size
  )

  echo "QR code sucessfully created!"
  echo fmt"QR code location: {getAppDir()}\{filename}.{filetype}"

dispatch(
  main,
  short = {
    "filename": 'n',
    "filetype": 't'
  },
  help = {
    "content": "the content of the QR code",
    "filename": "The filename of the image of the QR code",
    "filetype": "The file format of the QR code",
    "bgColor": "The background color of the QR code (will be black if invalid)",
    "fgColor": "The foreground color of the QR code (will be black if invalid)",
    "size": "The size of the QR code (in pixels)"
  }
)
