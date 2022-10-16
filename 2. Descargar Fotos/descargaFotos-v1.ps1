# T�tulo: Descarga automatizada de imagenes de una p�gina web
# Fecha: 26/09/2022
# Autor: Xavi Garc�a (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1

##################################
#                                #
# CONTENIDO CON FINES EDUCATIVOS #
#                                #
##################################

#1. Realiza un FORK del proyecto en tu GITHUB y clona el repositorio a tu ordenador local
#2. Modifica el SCRIPT para que realice la descarga automatizada de un gran conjunto de im�genes de otra p�gina web
#3. Modifica el SCRIPT para que el nombre de la imagen descargada sea el t�tulo (h3) o el atributo (alt) de la imagen
#4. Mejora el script para que cree una carpeta y almacene todas las im�genes en ella
#5. Mejora el script para que automatice la descarga de todas las imagenes de un sitio web introducido por el usuario

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"
$separador = "-"*50

$wc = New-Object System.Net.WebClient
$contadorIMG = 1

Write-Host "[+]Descargando im�genes del servidor..."
Write-Host "[!]Este proceso puede tardar unos minutos..."
Write-Host $separador

for ($i=1; $i -lt 10; $i++) {
    $peticion = Invoke-WebRequest -Uri "https://www.giantbomb.com/one-piece/3025-468/characters/?page=$i"
    $HTML = New-Object -Com "HTMLFile"
    $HTML.IHTMLDocument2_write($peticion.RawContent)
    $titulos = $HTML.all.tags("h3") | Where className -EQ "title" | % innerText
    $imagenes = $HTML.all.tags("div") | Where className -EQ "img imgboxart imgcast"
    #$imagenes = $peticion.Images | Select src
    $contadorH3 = 0
    foreach($imagen in $imagenes){
        $urlImagen = $imagen.innerHTML | Select-String -Pattern '(http[s]?)(:\/\/)(www\.giantbomb\.com\/a)([^\s,]+)(?=")' -AllMatches | % { $_.Matches } | % { $_.Value }	
        #if ($imagen -like 'https://www.giantbomb.com/a/uploads/square_small*') {
        $titulo = $titulos[$contadorH3]
        #$ruta = "./imagenes/$contadorIMG.$titulo.png"
        $wc.DownloadFile($urlImagen,"$contadorIMG.$titulo.png")
        $contadorH3++
        $contadorIMG++
        #}
    }    
}

Write-Host "[+]Se han descargado un total de $contadorIMG im�genes"

$ErrorActionPreference = "Continue"
$ProgressPreference = "Continue"