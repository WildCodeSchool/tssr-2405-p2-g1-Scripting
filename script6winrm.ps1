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