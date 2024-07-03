# Variables
$remoteIP = Read-Host "Entrer l'adresse IP du client"  # Adresse IP du PC Windows 10
$username = Read-Host "Entrer le nom d'utilosateur"  # Nom d'utilisateur sur le PC Windows 10
#$scriptPath = "C:\Users\Administrateur\Documents\nouveau4.ps1"  # Chemin du script à exécuter

# Demander les informations d'identification
$credential = Get-Credential -UserName $username -Message "Enter the password for $username@$remoteIP"

# Créer une session distante
$session = New-PSSession -ComputerName $remoteIP -Credential $credential

# Copier le script sur la machine distante
#Copy-Item -Path $scriptPath -Destination "C:\Users\Administrateur\nouveau4.ps1" -ToSession $session

# Exécuter le script à distance
Invoke-Command -Session $session -ScriptBlock {
    function Show-Menu {
    param (
        [string[]]$Choices
    )
    
    Write-Host "Veuillez sélectionner une ou plusieurs options (separees par des virgules) :"
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
	    $username = Read-Host "Entrez le nom d'utilisateur"
	    $password = Read-Host -AsSecureString "Entrez le mot de passe"
	    
	    try {
	        New-LocalUser -Name $username -Password $password -FullName $username -Description "utilisateur ajoute par script"
	        Add-LocalGroupMember -Group "Utilisateurs" -Member $username
	        Write-Host "Utilisateur '$username' ajoute avec succès."
	    } catch {
	        Write-Host "Erreur lors de l'ajout de l'utilisateur : $_"
		}
	Main
	}
	
	#fonction liste utilisateurs
	function List-LocalUsers {
		try {
			 $localUsers = Get-LocalUser
			 Write-Host "Liste des utilisateurs locaux"
			foreach ($user in $localUsers) {
			Write-Host "Nom d'utilisateur : $($User.name)"
			}
		} catch {
			Write-Host "Erreur lors de la recuperation de la liste des utilisateurs locaux : $_"
		}
	Main
	}
	# suppression d'utilisateur 
	function Remove-User {
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
	Main
	}
	# Lister les imprimantes et leurs ports sur l'ordinateur distant
	function List-PrintersRemote {
	    param (
	        [string]$remoteIp
	    )
	
	     {
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
	    }
	 Main
	}
	# Lister les imprimantes et afficher les résultats
	$printersList = List-PrintersRemote -Session $session
	
	# Afficher les résultats
	$printersList | Format-Table -AutoSize
	
	Write-Host "Liste des imprimantes récupérée avec succès."
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
	        [string[]]$Choices
	    )
	    
	    switch ($Selection) {
	        1 { Add-User }
	        2 { List-LocalUsers }
	        3 { Remove-User }
			4 {list-printersremote }
			5 {Exit-script}
			       
	        default { Write-Host "Option inconnue." }
	    } 
		
	}
	
	
	function Main {
	    $choices = @("ajouter un utilisateur", "Lister les utilisateurs locaux", "Supprimer Utilisateur"," liste des imprimantes", "Quitter")
	    do {
	        $selection = Show-Menu -Choices $choices
	        $validSelection = Validate-Selection -Selection $selection -MaxValue $choices.Length
			if ($validSelection -eq 4) {
				Execute-Action -Selection $validSelection -Choices $choices
				break
			} elseif ($validSelection){
				Execute-Action -Selection $validSelection -Choices $choices
			}
	    } until ($validSelection)
		
	
	    
	    
	}
	
	Main
	}
	
	# Fermer la session distante
	#Remove-PSSession -Session $session
