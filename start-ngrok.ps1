# Lance le tunnel ngrok vers le backend (port 5000).
# L'app mobile, l'admin (/) et le scout (/scout) passent tous par ce backend.
# Usage :  .\start-ngrok.ps1
$ngrok  = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Ngrok.Ngrok_Microsoft.Winget.Source_8wekyb3d8bbwe\ngrok.exe"
$config = "$env:LOCALAPPDATA\ngrok\ngrok.yml"
& $ngrok http --url=epineurial-itzel-enquiringly.ngrok-free.dev 5000 --config $config
