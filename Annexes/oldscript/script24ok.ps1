# Demander Ã  l'utilisateur de saisir l'adresse IP de la machine distante
$remoteIp = Read-Host "Veuillez entrer l'adresse IP de la machine distante"
$username = "Administrateur"

$password = Read-Host -AsSecureString "Veuillez entrer le mot de passe"
$password | ConvertFrom-SecureString | Out-File "C:\Users\Administrateur\Documents\secure_password.txt"
# VÃ©rifier si WinRM est installÃ© et en cours d'exÃ©cution
$winrmService = Get-Service -Name winrm -ErrorAction SilentlyContinue
if (-not $winrmService) {
    Write-Output "WinRM n'est pas installÃ© sur cette machine."
    exit
}

# DÃ©marrer le service WinRM s'il n'est pas dÃ©jÃ  en cours d'exÃ©cution
if ($winrmService.Status -ne 'Running') {
    Write-Output "DÃ©marrage du service WinRM..."
    Start-Service -Name winrm
}

# Configurer WinRM si nÃ©cessaire
$winrmListener =  winrm get winrm/config/Listener?Address=*+Transport=HTTP 2>&1  
if ($winrmListener -is [System.Management.Automation.ErrorRecord]) {
    Write-Output "Configuration de WinRM..."
    winrm quickconfig -quiet
}

# Ajouter l'IP de la machine distante Ã  la liste des hÃ´tes de confiance
Write-Output "Ajout de l'adresse IP $remoteIp Ã  la liste des hÃ´tes de confiance..."
Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force
#-Value $remoteIp -Force
#$username = Get-Content "C:\Users\Administrateur\Documents\username.txt"
$securePassword = Get-Content "C:\Users\Administrateur\Documents\secure_password.txt" | ConvertTo-SecureString
# Demander les informations d'identification de l'utilisateur
$cred = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# CrÃ©er une session distante avec l'adresse IP spÃ©cifiÃ©e
try {
    Write-Output "Ã‰tablissement de la session distante avec $remoteIp..."
    $session = New-PSSession -ComputerName $remoteIp -Credential $cred -Authentication Default
    Write-Output "Session Ã©tablie avec succÃ¨s Ã  $remoteIp"
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
	        Write-Host "Utilisateur '$username' ajoute avec succÃ¨s."
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
        
        Main	 	
    }
	
	

# Lister les imprimantes et afficher les rÃ©sultats
$printersList = List-PrintersRemote  #-Session $session

# Afficher les rÃ©sultats
$printersList | Format-Table -AutoSize


     } catch {Write-Host "Liste des imprimantes rÃ©cupÃ©rÃ©e avec succÃ¨s."}

	Main
}


# Fonction pour vÃ©rifier l'espace disque
function Check-DiskSpace {
    param (
        [string]$remoteIp
    )

    try {
        # Créer une session distante
        #$session = New-PSSession -ComputerName $remoteIp
        
        # Exécuter les commandes sur l'ordinateur distant
        $diskSpace = Invoke-Command -Session $session -ScriptBlock {
            Get-PSDrive -PSProvider FileSystem | Select-Object Name, 
                @{Name="FreeSpace(GB)";Expression={[math]::round($_.Free / 1GB, 2)}}, 
                @{Name="UsedSpace(GB)";Expression={[math]::round(($_.Used) / 1GB, 2)}}, 
                @{Name="TotalSize(GB)";Expression={[math]::round(($_.Used + $_.Free) / 1GB, 2)}}
        }

        # Afficher les résultats
        $diskSpace | Format-Table -AutoSize
        
        # Fermer la session distante
        #Remove-PSSession -Session $session
    }
    catch {
        Write-Host "Erreur lors de la vérification de l'espace disque : $_"
    }
    Main 
}

# Exemple d'appel de la fonction avec l'adresse IP distante
#Check-DiskSpace -remoteIp $remoteIP 



# choix pour sortir
function Exit-Script {
	Write-Host "sortie du script. A bientot"
	exit
}
Main
	
	
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
	4 { list-printersremote }   
	5 { Check-DiskSpace }
	6 { Exit-script }
			       
	default { Write-Host "Option inconnue." }
	} 
		
}
	
	
	function Main {
	    $choices = @("ajouter un utilisateur", "Lister les utilisateurs locaux", "Supprimer Utilisateur", "liste des imprimantes", "verifier l'espace disque disponible", "Quitter")
	    do {
	        $selection = Show-Menu -Choices $choices
	        $validSelection = Validate-Selection -Selection $selection -MaxValue $choices.Length
			if ($validSelection -eq 6 ) {
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


		 
		
