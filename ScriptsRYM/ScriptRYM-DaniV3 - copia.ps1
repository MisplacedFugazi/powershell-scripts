# Título: Obtener 100 mejores posiciones de RYM
# Fecha: 23/09/2022
# Autor: Dani Martos -bifurcado de Xavi García (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1 (get-host)-enter

#Este script se conecta a RYM , una web que es una base de datos en red sobre música  
#con el fin de que los usuarios califiquen, reseñen y cataloguen sus colecciones de obras musicales (LP, EP, singles, etc).
#Estos datos son usados para crear recomendaciones a los mismos usuarios. 
#Es importante señalar que son los propios usuarios los que van aportando los datos de los que se nutre la web
#(es decir, artistas y/o grupos musicales, así como los trabajos que estos han editado), por lo que en principio se basa en un modelo wiki,
#pero ciertas modificaciones deben ser aprobadas por los moderadores.

#El script descargara automaticamente las 100 mejores posiciones de discos de un año introducido por el usuario(entre 1920 y 2022) en imagenes

#Falta : Sustituir los image block por una foto por defecto y mantener el nombre de disco
#        Cambiar read-host por param y poder introducir comandos para filtrar los resultados(singles,bandas sonoras,directos)
#        Añadir nombres a una plantilla excel

$separador = "-"*50
$ProgressPreference = "SilentlyContinue" #no salgan errores en pantalla
$ErrorActionPreference = 'SilentlyContinue'
clear-host 

#comrpobar path

$path = "$env:USERPROFILE\OneDrive\Escritorio\"

if (Test-Path -Path $path) {
    #continua
} else {
    $path = "$env:USERPROFILE\Desktop\"
    
        if (Test-Path -Path $path) {
            #continua
        } else {
            $path = "$env:USERPROFILE\"
            }
    }

#pedir año para el url

 do{
        $año = read-host "Introduce el año del que deseas obtener el top 100 [-h : para ayuda] "
    }
  until($año -le 2022 -and $año -ge 1920)


#cada url contiene solo 40 posiciones , por lo tanto se han de crear tres urls
    
        $Url = "https://rateyourmusic.com/charts/top/album/$año/$pag" #la url pasa a ser la del año introducido 

        $genera = Invoke-WebRequest -Uri $Url #peticion para recoger elementos de un url
        $images = ($genera).Images  #propiedad que recoge informacion de la url
        $urlimagen   = $images | Select -ExpandProperty src #recoge la src(url de la imagen)
        $nombredisco = $images | Select -ExpandProperty alt #selecciona la descripcion de la imagen en este caso el nombre del disco
        $arraynombres = @($nombredisco) #añado las peticiones en arrays para poder moverme con un bucle
        $arrayimagenes = @($urlimagen)

#crear carpeta del año introducido

        $null = New-Item "$path\Cover\$año" -itemType Directory

#bucle descarga 1 {desde el disco 1 al 40}
write-host $separador
write-host "[!]Descargando fotos..."
write-host  " "

for($i=0;$i -lt 4; $i++)
                        {
                         $num=$i+1
                         $peticio=  $urlimagen[$i].TrimStart('//')
                         $nombreord = $nombredisco[$i].TrimEnd(',Cover art')
                         $nomfinal = "$num.$nombreord"
                         write-host $nomfinal
                         $null2 = Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpg"
                         }


$urlimagen   = $images | Select -ExpandProperty data-src #recoge la src(url de la imagen

for($j=0;$j -lt 36; $j++)
                        {
                         $ProgressPreference = "SilentlyContinue"
                         $num=$j+5
                         $peticio=  $urlimagen[$j].TrimStart('//')
                         $nombreord = $nombredisco[$num-1].TrimEnd(',Cover art')
                         $nomfinal = "$num.$nombreord"
                         write-host $nomfinal
                         Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpg">$null3
                         }

$Url = "https://rateyourmusic.com/charts/top/album/$año/2" #la url pasa a ser la del año introducido 

        $genera = Invoke-WebRequest -Uri $Url #peticion para recoger elementos de un url
        $images = ($genera).Images  #propiedad que recoge informacion de la url
        $urlimagen   = $images | Select -ExpandProperty src #recoge la src(url de la imagen)
        $nombredisco = $images | Select -ExpandProperty alt #selecciona la descripcion de la imagen en este caso el nombre del disco
        $arraynombres = @($nombredisco) #añado las peticiones en arrays para poder moverme con un bucle
        $arrayimagenes = @($urlimagen)

#bucle descarga 2 {desde el disco 41 al 80}    

for($i=0;$i -lt 4; $i++)
                        {
                         $num=$i+41
                         $peticio=  $urlimagen[$i].TrimStart('//')
                         $nombreord = $nombredisco[$i].TrimEnd(',Cover art')
                         $nomfinal = "$num.$nombreord"
                         write-host $nomfinal
                         $null2 = Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpeg"
                         }


$urlimagen   = $images | Select -ExpandProperty data-src #recoge la src(url de la imagen

for($j=0;$j -lt 37; $j++)
                        {
                         $num=$j+5
                         $num2=44+$j
                         $peticio=  $urlimagen[$j].TrimStart('//')
                         $nombreord = $nombredisco[$num-1].TrimEnd(',Cover art')
                         $nomfinal = "$num2.$nombreord"
                         write-host $nomfinal
                         Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpeg">$null3
                         }

$Url = "https://rateyourmusic.com/charts/top/album/$año/3" #la url pasa a ser la del año introducido 

        $genera = Invoke-WebRequest -Uri $Url #peticion para recoger elementos de un url
        $images = ($genera).Images  #propiedad que recoge informacion de la url
        $urlimagen   = $images | Select -ExpandProperty src #recoge la src(url de la imagen)
        $nombredisco = $images | Select -ExpandProperty alt #selecciona la descripcion de la imagen en este caso el nombre del disco
        $arraynombres = @($nombredisco) #añado las peticiones en arrays para poder moverme con un bucle
        $arrayimagenes = @($urlimagen)

#bucle descarga 3 {desde el disco 81 al 100}

for($i=0;$i -lt 4; $i++)
                        {
                         $num=$i+81
                         $peticio=  $urlimagen[$i].TrimStart('//')
                         $nombreord = $nombredisco[$i].TrimEnd(',Cover art')
                         $nomfinal = "$num.$nombreord"
                         write-host $nomfinal
                         $null2 = Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpeg"
                         }


$urlimagen   = $images | Select -ExpandProperty data-src #recoge la src(url de la imagen

for($j=0;$j -lt 13; $j++)
                        {
                         $num=$j+5
                         $num2=88+$j
                         $peticio=  $urlimagen[$j].TrimStart('//')
                         $nombreord = $nombredisco[$num-1].TrimEnd(',Cover art')
                         $nomfinal = "$num2.$nombreord"
                         write-host $nomfinal
                         Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpeg">$null3
                         }


