# Demander à l'utilisateur de saisir l'adresse IP de la machine distante
$remoteIp = Read-Host "Veuillez entrer l'adresse IP de la machine distante"
$username = "Administrateur"

$password = Read-Host -AsSecureString "Veuillez entrer le mot de passe"
$password | ConvertFrom-SecureString | Out-File "C:\Users\Administrateur\Documents\secure_password.txt"
# Vérifier si WinRM est installé et en cours d'exécution
$winrmService = Get-Service -Name winrm -ErrorAction SilentlyContinue
if (-not $winrmService) {
    Write-Output "WinRM n'est pas installé sur cette machine."
    exit
}

# Démarrer le service WinRM s'il n'est pas déjà en cours d'exécution
if ($winrmService.Status -ne 'Running') {
    Write-Output "Démarrage du service WinRM..."
    Start-Service -Name winrm
}

# Configurer WinRM si nécessaire
$winrmListener =  winrm get winrm/config/Listener?Address=*+Transport=HTTP 2>&1  
if ($winrmListener -is [System.Management.Automation.ErrorRecord]) {
    Write-Output "Configuration de WinRM..."
    winrm quickconfig -quiet
}

# Ajouter l'IP de la machine distante à la liste des hôtes de confiance
Write-Output "Ajout de l'adresse IP $remoteIp à la liste des hôtes de confiance..."
Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force
#-Value $remoteIp -Force
#$username = Get-Content "C:\Users\Administrateur\Documents\username.txt"
$securePassword = Get-Content "C:\Users\Administrateur\Documents\secure_password.txt" | ConvertTo-SecureString
# Demander les informations d'identification de l'utilisateur
$cred = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# Créer une session distante avec l'adresse IP spécifiée
try {
    Write-Output "Établissement de la session distante avec $remoteIp..."
    $session = New-PSSession -ComputerName $remoteIp -Credential $cred -Authentication Default
    Write-Output "Session établie avec succès à $remoteIp"
} catch {
    Write-Output "Erreur lors de la tentative de connexion : $_"
    exit
}
# Fonction pour afficher le menu
function Show-Menu {
    param (
        [string[]]$Choices
    )
    
    Write-Host "Veuillez selectionner une ou plusieurs options (separees par des virgules) :"
    for ($i = 0; $i -lt $Choices.Length; $i++) {
        Write-Host "$($i + 1). $($Choices[$i])"
    }
    
    $selections = Read-Host "Entrez les numeros de vos choix"
    return $selections -split ',' | ForEach-Object { $_.Trim() }
}

#choix pour valider la selection

function Validate-Selection {
    param (
        [string[]]$Selections,
        [int]$MaxValue
    )
    
    if ([int]::TryParse($Selection, [ref]$null) -and $Selection -gt 0 -and $Selection -le $MaxValue) {
        return [int]$Selection
    } else {
        Write-Host "'$Selection' n'est pas un choix valide."
        return $null
			
        }
    
    
}
#fonction ajout utilisateur
	function Add-User {
		 param (
        [string]$remoteIp
    )
		Invoke-Command -Session $session -ScriptBlock {
	    $username = Read-Host "Entrez le nom d'utilisateur"
	    $password = Read-Host -AsSecureString "Entrez le mot de passe"
	    
	    try {
	        New-LocalUser -Name $username -Password $password -FullName $username -Description "utilisateur ajoute par script"
	        Add-LocalGroupMember -Group "Utilisateurs" -Member $username
	        Write-Host "Utilisateur '$username' ajoute avec succès."
	    } catch {
	        Write-Host "Erreur lors de l'ajout de l'utilisateur : $_"
		}
		}
	Main
	}
	
	#fonction liste utilisateurs
	function List-LocalUsers {
		 param (
        [string]$remoteIp
    )
		try {
			Invoke-Command -Session $session -ScriptBlock {
			 $localUsers = Get-LocalUser
			 Write-Host "Liste des utilisateurs locaux"
			foreach ($user in $localUsers) {
			Write-Host "Nom d'utilisateur : $($User.name)"
			}
			}
		} catch {
			Write-Host "Erreur lors de la recuperation de la liste des utilisateurs locaux : $_"
		}
	Main
	}
	
	# suppression d'utilisateur 
	function Remove-User {
		 param (
        [string]$remoteIp
    ) 
		Invoke-Command -Session $session -ScriptBlock {
			$username = Read-Host "Entrez le nom d'utilisateur a supprimer"
		
		try {
			$user =Get-LocalUser -Name $username
			if ($user) {
				Remove-LocalUser -Name $username
				Write-Host "utilisateur '$username' supprime avec succes."
			} else {
				Write-Host "Utilisateur '$username' n'existe pas."
			}
		} catch {
			Write-Host "Erreur lors de la suppression de l'utilisateur : $_"
		}
		}
	Main
	}
	
	


# Fonction pour vérifier l'espace disque
function Check-DiskSpace {
    param (
        [string]$remoteIp
    )

    try {
        
        
        # Executer les commandes sur l'ordinateur distant
        $diskSpace = Invoke-Command -Session $session -ScriptBlock {
            Get-PSDrive -PSProvider FileSystem | Select-Object Name, 
                @{Name="FreeSpace(GB)";Expression={[math]::round($_.Free / 1GB, 2)}}, 
                @{Name="UsedSpace(GB)";Expression={[math]::round(($_.Used) / 1GB, 2)}}, 
                @{Name="TotalSize(GB)";Expression={[math]::round(($_.Used + $_.Free) / 1GB, 2)}}
        }

        # Afficher les resultats
        $diskSpace | Format-Table -AutoSize
        
       
    }
    catch {
        Write-Host "Erreur lors de la verification de l'espace disque : $_"
    }
    Main 
}
#Liste des groupes d'un utilisateur
function Get-localGroupMember {

        param ([string]$remoteIp )

    $username_user = Read-Host "quelle utilisateur voulez vous cibler? "
    if (Invoke-Command -ScriptBlock { param($username) Get-LocalUser -Name $username 2> $null } -ArgumentList $username_user -Session $session)  
    {
        Write-Output "Liste des groupes auxquels appartient l'utilisateur $username_user" >> $info_log
        Invoke-Command -ScriptBlock { param($username) (net user $username)[22,23] } -ArgumentList $username_user -Session $session 
        Invoke-Command -ScriptBlock { param($username) (net user $username)[22,23] } -ArgumentList $username_user -Session $session >> $info_log

        $message = "affichage a quelle groupe appartient l'utilisateur"
         
        
    }
    else
    {
        write-host "L'utilisateur n'existe pas"
        
        
    }
    Main
}
#Ajout au groupe Administrateurs
Function AddAdminGroup {
     param ([string]$remoteIp )  

    $username = Read-Host "Nommez l'utilisateur"
    $confirm = Read-Host "Voulez vous vraiment ajouter $nomUtilisateur au groupe d'administration? Taper [o] pour confirmer."
    if ($confirm -eq "o") {
        try {
            # Verifier si l'utilisateur est deja membre du groupe des administrateurs
            $isMember = Invoke-Command -Session $session -ScriptBlock {
                param ($username)
                $group = Get-LocalGroupMember -Group "Administrateurs"
                return $group.Name -contains $username
            } -ArgumentList $username

            if ($isMember) {
                Write-Host "L'utilisateur $username fait deja partie du groupe Administrateurs" -ForegroundColor Red
			break			}   
			else {
        Invoke-Command -ScriptBlock { param($username) Add-LocalGroupMember -Group Administrateurs -Member $username } -ArgumentList $username -Session $session
        Write-Host "$username a bien ete ajoute au groupe Administrateurs" -ForegroundColor Green
        }
          
    } catch {
			Write-Host "Erreur lors de l'ajout de l'utilisateur : $_"
		}# else {
        #Write-Host "Ajout annul鮢 -ForegroundColor Yellow 
    
    
    #$message = "$nomUtilisateur a bien ete ajouter au groupe administrateurs"
    #Write-Log $message
		}
	Main
}
# Lister les imprimantes et leurs ports sur l'ordinateur distant
function List-PrintersRemote {
    param (
        [string]$remoteIp
    )

    try {Invoke-Command -Session $session -ScriptBlock {
        $printers = Get-Printer
        $printerPorts = Get-PrinterPort

        $printers | ForEach-Object {
            $printer = $_
            $port = $printerPorts | Where-Object { $_.Name -eq $printer.PortName }
            [PSCustomObject]@{
                PrinterName = $printer.Name
                PrinterPortName = $printer.PortName
                PrinterIPAddress = if ($port) { $port.PrinterHostAddress } else { "N/A" }
				
            }
        }
	 	
    
	
	

# Lister les imprimantes et afficher les résultats
#$printersList = List-PrintersRemote  -Session $session

# Afficher les résultats
	$printersList | Format-Table -AutoSize }


     } catch {Write-Host "Liste des imprimantes récupérée avec succès."}

	Main
}

#recuperation des logs
Function Get-Log {
		 #param (
        #[string]$remoteIp )
		
		

# Créer une fonction pour écrire les logs
#function WriteLog {
   # param (
        #[string]$message
   # )
	#$logFile = "C:\Users\Administrateur\Documents\log.txt"
    #$message | Out-File -FilePath $logFile -Append -Encoding json


# ScriptBlock à exécuter sur la machine distante
	    param ([string]$remoteIP )
		 #Get-EventLog $session
		Invoke-Command -Session $session  -ScriptBlock  {
    Get-EventLog -LogName System | Out-File "C:\Users\Administrateur\Documents\log.txt" -Encoding utf8 
	#$LogFile = "C:\Users\Administrateur\Documents\log.txt"
    Write-Host "Les logs systeme ont ete extraits dans le fichier : $logFile"

}				
Main 
}
#recuperation des IP et MAC Adresse 
function  get-Addresse-IP-MAC { 
		 param ( 
		[string] $remoteIp 
		)
		
		Invoke-Command -Session $session { 
		$ipInfo = Get-NetIPAddress  #-AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "Loopback*"} 
        Write-Host "$ipInfo"
    
    # Get MAC Address information
		$macAddress = ( Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -ExpandProperty MacAddress).ToUpper()
		Write-Host "$macAddress" }
     #Create an object to store the information
      $computerInfo  

    # Output the information
    $computerInfo | Format-Table -AutoSize
		
	Main	
}	
#info pc
function system-info {
	 param ( 
		[string] $remoteIp)
		
	Invoke-Command -Session $session -ScriptBlock { get-computerinfo }
		
		
	Main
	
	}
	
	
 






# choix pour sortir
function Exit-Script {
	Write-Host "sortie du script. A bientot"
	exit
}

	
	
#liste des choix possible
function Execute-Action {
	param (
	[int]$Selection,
	[string[]]$Choices, $remoteIP 
	)
	    
	switch ($Selection) {
	1 { Add-User }
	2 { List-LocalUsers }
	3 { Remove-User }
    4 { Get-LocalGroupMember }
    5 { AddAdminGroup }
	6 { list-printersremote }   
	7 { Check-DiskSpace } 
	8 { Get-Log }
	9 { get-Addresse-IP-MAC }	
	10 { Exit-script }
			       
	default { Write-Host "Option inconnue." }
	} 
		
}
	
	
	function Main {
	    $choices = @("ajouter un utilisateur", "Lister les utilisateurs locaux", "Supprimer Utilisateur","membre des Groupes d'un utilisateur", "ajouter un utilisateur au groupe Administrateurs", "liste des imprimantes", "verifier l'espace disque disponible","recuperation des logs", "Adresse IP et MAC", "Quitter")
	    do {
	        $selection = Show-Menu -Choices $choices
	        $validSelection = Validate-Selection -Selection $selection -MaxValue $choices.Length
			if ($validSelection -eq 11 ) {
				Execute-Action -Selection $validSelection -Choices $choices
				break
			} elseif ($validSelection){
				Execute-Action -Selection $validSelection -Choices $choices
			}
	    } until ($validSelection)
		
	
	    
	    
	}
	
	Main
	
	
	# Fermer la session distante
	#Remove-PSSession -Session $session


		 
		
