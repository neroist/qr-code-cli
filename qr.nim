import httpclient
import uri
import strformat
import strutils

const
  Filetypes* = [
    "png",
    "gif",
    "jpeg",
    "jpg",
    "svg",
    "eps"
  ]

  Uri* = parseUri "http://api.qrserver.com/v1/create-qr-code"

let
  client = newHttpClient()

proc qrCode*(
  data,
  filename: string,
  filetype = "png",
  bgColor = "ffffff",
  fgColor = "000000";
  size = 200) =

  doAssert size < 999, "Size too large"
  doAssert filetype.toLowerAscii() in Filetypes, "Invalid filetype. Must be in the array: " & $Filetypes

  let
    response = client.get(
      Uri ? {
        "data": data,
        "format": filetype.toLowerAscii(),
        "color": fgColor,
        "bgcolor": bgColor,
        "size": fmt"{size}x{size}"
      }
    )

  writeFile(fmt"{filename}.{filetype}", response.body)