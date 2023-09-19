################################################################################
##  File:  Install-AzureDevOpsCli.ps1
##  Desc:  Install Azure DevOps CLI
################################################################################

# Store azure-devops-cli cache outside of the provisioning user's profile
$azureDevOpsCliConfigPath = Join-Path $Env:CommonProgramFiles 'AzureDevOpsCliConfigDirectory'
$null = New-Item -ItemType "Directory" -Path $azureDevOpsCliConfigPath
Set-SystemVariable -SystemVariable "AZURE_DEVOPS_EXT_CONFIG_DIR" -value $azureDevOpsCliConfigPath

$azureDevOpsCliCachePath = Join-Path $azureDevOpsCliConfigPath "cache"
$null = New-Item -ItemType "Directory" -Path $azureDevOpsCliCachePath
Set-SystemVariable -SystemVariable "AZURE_DEVOPS_CACHE_DIR" -value $azureDevOpsCliCachePath

Invoke-ValidateCommand -Command "az extension add -n azure-devops"

# Warm-up Azure DevOps CLI

Write-Host "Warmup 'az-devops'"
@("devops", "pipelines", "boards", "repos", "artifacts") | ForEach-Object {
    Invoke-ValidateCommand -Command "az $_ --help"
}

Invoke-PesterTests -TestFile "CLI.Tools" -TestName "Azure DevOps CLI"
