@echo off
echo Creating keystore for Faylav WebView App

REM Set key information
set KEY_ALIAS=faylav
set KEY_PASSWORD=faylav2024
set STORE_PASSWORD=faylav2024
set VALIDITY=10000
set KEYSTORE_FILE=faylav-keystore.jks

REM Generate the keystore
echo Generating keystore file...
keytool -genkey -v -keystore %KEYSTORE_FILE% -alias %KEY_ALIAS% -keyalg RSA -keysize 2048 -validity %VALIDITY% -storepass %STORE_PASSWORD% -keypass %KEY_PASSWORD% -dname "CN=Faylav, OU=Mobile, O=Faylav, L=Unknown, ST=Unknown, C=US"

echo.
echo Keystore created successfully!
echo   Keystore file: %KEYSTORE_FILE%
echo   Key alias: %KEY_ALIAS%
echo   Key password: %KEY_PASSWORD%
echo   Store password: %STORE_PASSWORD%
echo.
echo IMPORTANT: Keep this information secure and update android/key.properties with these values.

REM Move keystore file to android folder
echo Moving keystore file to android folder...
copy %KEYSTORE_FILE% android\app\
echo Done!

REM Create key.properties file
echo Creating key.properties file...
(
echo storePassword=%STORE_PASSWORD%
echo keyPassword=%KEY_PASSWORD%
echo keyAlias=%KEY_ALIAS%
echo storeFile=app/%KEYSTORE_FILE%
) > android\key.properties

echo.
echo Key.properties file created successfully!
echo Ready to build signed app. 