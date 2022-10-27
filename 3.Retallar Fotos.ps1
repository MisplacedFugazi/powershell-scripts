# Título: Recorta imágenes en porciones mas pequeñas
# Fecha: 24/10/2022
# Autor: Xavi García (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1

##################################
#                                #
# CONTENIDO CON FINES EDUCATIVOS #
#                                #
##################################

#1. Realiza un FORK del proyecto en tu GITHUB y clona el repositorio a tu ordenador local
#2. Mejora el SCRIPT para que detecte el ancho y alto de la imagen y realice los recortes adecuados
#3. Mejora el SCRIPT para que pida al usuario el número de filas y columnas a recortar y el nombre de la imagen

clear-host

$ubicacio=Read-Host "A quina Carpeta esta ubicada la foto que vols?[ex:Escritorio,Desktop,Descargas,Downloads]" #Pregunta per la ruta on tens les fotos

$path = "$env:USERPROFILE\OneDrive\$ubicacio\*"  #defineix el path amb carpeta que tu has introduit

if(!(Test-Path -Path $path)){                        #si la ruta no existeix a OneDrive comrpova el path a la carpeta del usuari en local
    $path = "$env:USERPROFILE\$ubicacio\*"
}

if(!(Test-Path -Path $path)){
    Write-Host "Carpeta no trobada , mostrant arxius de la carpeta $env:USERPROFILE"    #si aquesta tampoc existeix , mostrara imatges del folder del usuari es a dir C:\Users\elteuusuari
    $path = "$env:USERPROFILE\*"
}

$mostra = Get-ChildItem -Path $path -Include *.jpg , *.png | Select Name #mostra les imatges de la carpeta

$null=''

if($mostra -eq $null){write-host "No hi han imatges a aquesta carpeta , sortint del script"} #si no hi ha imatges per mostrar al folder

else{
    Write-host  " "
    Write-host "Aquestes son les imatges ubicades a la teva carpeta : " 
    Write-host  " "
    $mostra.name  #mostra les imatges de la ruta que hsa seleccionat
    Write-host  " "
    $imgretall=read-host "Quina imatge vols retallar?ex:"$mostra.name[0]
    $pathrim=$path.TrimEnd('*')

    if(Test-Path -Path $pathrim$imgretall){     #aixo controla si el arxiu es en png o jpg
        if($imgretall -like "*.jpg"){
                $formato=".jpg"
                $imgrettrim=$imgretall.TrimEnd($formato)
                }
            else{$formato=".png" 
                 $imgrettrim=$imgretall.TrimEnd($formato)}
        #continua
        $imagen  = New-Object System.Drawing.Bitmap("$pathrim$imgretall") #recull les dades de la imatge
        $filas = read-host "Quantes files te la foto?"
        $columnas = read-host "Quantes columnes te la foto?"
        $contadorImagenes = 1
        $pathrec = $path.TrimEnd('*') + "Recortes"    #controlar que la carpeta recortes existeixi a la teva carpeta de seleccio

        if(Test-Path -Path $pathrec ){ 
            Write-host "Carpeta Recortes trobada a $pathrec "  
            }else{
                $crea=New-Item $pathrec -itemType Directory    #si no la troba , la creara a la carpeta que ho vols
                Write-host "Carpeta Recortes creada a $pathrec "
            }
    
    $calculheight=$imagen.Height/$filas    #divideix altura per files
    $calculwidth=$imagen.Width/$columnas   #divideix altura per columnes
    
    Write-Host "[!]Retallant Imatges..."

    for($i=0; $i -lt $filas; $i++){
        for($j=0; $j -lt $columnas; $j++){
            $x = $j * $calculwidth
            $y = $i * $calculheight
            $ventana = New-Object System.Drawing.Rectangle($x,$y,$calculwidth,$calculheight)#retall de la imatge
            $recorte = $imagen.Clone($ventana, $imagen.PixelFormat) #clona el retall en una nova imatge
            $recorte.Save("$pathrec\$imgrettrim$contadorImagenes$formato") #exportes-guardes la imatge a la ruta final amb el nom original de l'arxiu mes un contador
            $contadorImagenes++
        }
    }
    Write-Host "[!]Imatges retallades!"

    }else{
        Write-Host "Arxiu $imgretall no trobat a  $pathrim [Sortint del Script]"   #la foto no s'ha trobat al path(has escrit malament el nom)     
    }
}

