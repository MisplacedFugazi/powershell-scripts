
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

#El script descargara automaticamente las 100 mejores posiciones de discos de un año introducido por el usuario(entre 1950 y 2022) , una decada (1990s) , un periodo de tiempo (1982.2001) o todos los tiempos en imagenes

$separador = "-"*50
$ProgressPreference = "SilentlyContinue" #no salgan errores en pantalla
$ErrorActionPreference = 'SilentlyContinue'
clear-host 
$añoactual=(Get-Date).year
#comrpobar path

$path = "$env:USERPROFILE\OneDrive\Escritorio\"

if (!(Test-Path -Path $path)) { $path = "$env:USERPROFILE\Desktop\"} 
if (!(Test-Path -Path $path)) { $path = "$env:USERPROFILE\"} 

#pedir año para el url

$request='false'
do{
$comando = read-host "Introduce que request quieres hacer a la pagina [-h para ayuda] "

Switch ($comando)
{
    '-h' {cls; 
            Write-Host "[-h]:Mostrando ayuda del script 
    `n[-y]:Introduce un año del 1950 al $añoactual y descargara los 100 mejores discos de ese año`n[-d]:Introduce una decada de los 1950s a los 2020s y mostrara los 100 mejores discos de esa decada`n[-g]:Introduce entre un año concreto a otro y mostrara los 100 mejores discos de ese periodo de tiempo`n[-a]:Descargara los 100 mejores discos de todos los tiempos segun esta pagina web`n[-i]:Informacion de la web y Script`n[-ex]:Salir del script`n"}
    '-y' {cls;
            do{$año = read-host "Introduce el año del que deseas obtener el top 100  "
                    }until($año -le $añoactual -and $año -ge 1950)
                            write-host "[!]100 Mejores discos de $año..."
                            $request='true'}
    '-d' {cls;
            $arrayaño = @(1950,1960,1970,1980,1990,2000,2010,2020)
              do{[int]$año = read-host "Introduce la decada que deseas (entre 1950 y 2020) "
                    }until($arrayaño.Contains($año) -eq 'true')
                            [string]$fin=$año
                            [string]$año=$fin+"s"
                            write-host "[!]100 Mejores discos de los $año..."
                            $request='true'}
    '-g' {cls;
            do{$año = read-host "Introduce el primer año del periodo que deseas obtener"
                    }until($año -le $añoactual -and $año -ge 1950)
            do{$año2 = read-host "Introduce el segundo año del periodo que deseas obtener[Ha de ser mayor a $año]"
                    }until($año2 -gt $año -and $año2 -le $añoactual)
                        $fin=$año+"-"+$año2
                        $año=$fin
                        write-host "[!]100 Mejores discos entre $año ..."
                        $request='true'}
    '-a' {cls;
            $año='all-time'
                        write-host "[!]100 Mejores discos de toda la historia..."
                        $request='true'}
    '-ex' {write-host "Cerrando el script..."
                exit}
    '-i' {cls;write-host "`nEste script se conecta a RYM , una web que es una base de datos en red sobre música  
con el fin de que los usuarios califiquen, reseñen y cataloguen sus colecciones de obras musicales (LP, EP, singles, etc).
Estos datos son usados para crear recomendaciones a los mismos usuarios. 
Es importante señalar que son los propios usuarios los que van aportando los datos de los que se nutre la web,
(es decir, artistas y/o grupos musicales, así como los trabajos que estos han editado), por lo que en principio se basa en un modelo wiki,
pero ciertas modificaciones deben ser aprobadas por los moderadores.`n`nEn cuanto a este script descargara automaticamente las 100 mejores posiciones de discos de un año introducido por el usuario(de 1950 a $añoactual),una decada (1990s) un periodo o todos los tiempos en imagenes.`n"
    }
    default {write-host "Opcion desconocida"}
}
}while($request -eq 'false')


        #Login a la web , baneo de ip publica 
        #Invoke-WebRequest -Uri "https://rateyourmusic.com/account/login?" -Method Post -Body @{username='danimartos';password='daani.97';}>$null25
        #Invoke-WebRequest -Uri "https://rateyourmusic.com/?login_success">$null26
                                              #Invoke-WebRequest -Uri "https://rateyourmusic.com/account/login?" -Method Post -Body @{username='danimartos';password=(ConvertTo-SecureString -String 'daani.97' -AsPlainText -Force);}

#cada url contiene solo 40 posiciones , por lo tanto se han de crear tres urls
write-host $separador
write-host "[!]Descargando fotos..."
write-host  " "

$pag=0

for($webs=0;$webs -le 2; $webs++){
   if($pag -eq 0){$max=36}
   elseif($pag -eq 2){$max=37}
   elseif($pag -eq 3){$max=13}

   $Url = "https://rateyourmusic.com/charts/top/album/$año/$pag" #la url pasa a ser la del año introducido 

        $genera = Invoke-WebRequest -Uri $Url #peticion para recoger elementos de un url
        $images = ($genera).Images  #propiedad que recoge informacion de la url
        $urlimagen   = $images | Select -ExpandProperty src #recoge la src(url de la imagen)
        $nombredisco = $images | Select -ExpandProperty alt #selecciona la descripcion de la imagen en este caso el nombre del disco
        $arraynombres1 = @($nombredisco) #añado las peticiones en arrays para poder moverme con un bucle
        $arrayimagenes = @($urlimagen)

#crear carpeta del año introducido

        $null = New-Item "$path\Cover\$año" -itemType Directory

#bucle descarga 1 {desde el disco 1 al 40} cuando necesite la pagina 2 ira del disco 41 al 80 y en la tercera ira del disco 80 al 100


for($i=0;$i -lt 4; $i++)
                        {
                         if($pag -eq 0){
                         $num=$i+1
                         }
                         elseif($pag -eq 2){
                         $num=$i+41
                         }
                         elseif($pag -eq 3){
                         $num=$i+81
                         }
                         $peticio=  $urlimagen[$i].TrimStart('//')
                         $nombreordpre = $nombredisco[$i].TrimEnd('Cover art')
                         $nombreord=$nombreordpre.TrimEnd(',')
                         $nomfinal = "$num.$nombreord"
                         write-host $nomfinal
                         $null2 = Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpg"
                         }


$urlimagen   = $images | Select -ExpandProperty data-src #recoge la src(url de la imagen

for($j=0;$j -lt $max; $j++)
                        {
                        if($pag -eq 0){
                         #$ProgressPreference = "SilentlyContinue"
                         $num=$j+5
                         
                         }
                         elseif($pag -eq 2){
                         $num=$j+5
                         $num2=44+$j
                         
                         }
                         elseif($pag -eq 3){
                         $num=$j+5
                         $num2=88+$j
                         
                         }
                         $peticio=  $urlimagen[$j].TrimStart('//')
                         $nombreordpre = $nombredisco[$num-1].TrimEnd('Cover art')
                         $nombreord=$nombreordpre.TrimEnd(',')
                         if($webs -gt 0){ $nomfinal = "$num2.$nombreord"}
                         elseif($webs -eq 0){$nomfinal = "$num.$nombreord"}
                         write-host $nomfinal
                         Invoke-WebRequest -Uri  $peticio -OutFile "$path\Cover\$año\$nomfinal.jpeg">$null3
                         }

    if($webs -eq 0 ){$pag=2;}
    elseif($webs -eq 1 ){$pag=3;}

   }
        

