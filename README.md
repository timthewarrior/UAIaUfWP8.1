# Universal App Installer and Updater for Windows Phone 8.1

A command-line tool to install or update apps on Windows Phone 8.1 devices using `.xap`, `.appx`, or `.appxbundle` files.

> **Requirements**  
> - Your device **must be jailbroken**  
> - The **Windows Phone 8.1 SDK** must be installed  
        - You can download Phone 8.1 SDK here: https://mega.nz/folder/ycJgUbjD#YimioYNHUL8SXy7XDifj8g
        - In case you still run into issues, also install Phone 8.0 SDK: https://mega.nz/folder/qYAwDTKa#CunfmIhIV9Jy80PmUBzZIg
> - Windows 7/8/10 with command-line access

## Features

- **Supports multiple formats**  
  Install or update `.xap`, `.appx`, and `.appxbundle` files.

- **Flexible usage**  
  Choose between installing/updating a **single file** or **bulk install/update** from a folder.

- **Optional app launch**  
  Automatically launch the app after install or update (only available in single file mode).

- **Progress indicators**  
  See what app of what is being installed (only available in folder mode).

## Usage

1. Run the script.
2. Choose one of the following:
   - **Install/Update a single file**
   - **Install/Update from a folder**
3. Follow the on-screen prompts to complete the process.

---

This tool uses the official `AppDeployCmd.exe` from the Windows Phone SDK for deployment.
