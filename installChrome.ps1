# ONE LINE - $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

# Определяем директорию для временных файлов
$temporaryDirectory = $env:TEMP

# Имя установщика Chrome
$chromeInstallerFileName = "ChromeInstaller.exe"

# Скачиваем установочный файл Chrome
$installerUrl = 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe'
$installerFilePath = "$temporaryDirectory\$chromeInstallerFileName"
(new-object System.Net.WebClient).DownloadFile($installerUrl, $installerFilePath)

# Запускаем установку Chrome в тихом режиме
Start-Process -FilePath $installerFilePath -ArgumentList '/silent', '/install' -Wait

# Имя процесса для отслеживания (установщик Chrome)
$installerProcessName = "ChromeInstaller"

# Ожидаем завершения процесса установки
do {
    # Получаем список процессов, связанных с установщиком
    $runningProcesses = Get-Process | Where-Object { $_.Name -eq $installerProcessName }

    if ($runningProcesses) {
        # Если установщик ещё работает, выводим сообщение и ждем 2 секунды
        Write-Host "Установщик еще работает..."
        Start-Sleep -Seconds 2
    } else {
        # Если установщик завершился, удаляем его
        Remove-Item -Path $installerFilePath -ErrorAction SilentlyContinue -Verbose
    }
} until (!$runningProcesses)
