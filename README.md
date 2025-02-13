# Sample Webclient application with Intellistream-like feature

Intellistream could have been a very good way of delivering Webclient application updates if only Progress had created a scriptable way of generating the `prowcapp` files.
As usual, it seems that nobody at Progress ever had to maintain a real Webclient application (beyond the demo application where it's useful to have a UI).

The application in this repository aims to provide an example of a bootstrap Webclient app that downloads application updates from a PASOE instance. Combined with [PDO](https://pdo.riverside-software.fr), you can have light MSI installers (less than 30MB in total) for your OpenEdge app, which can be deployed automatically through SCCM or Intune.

The code in this repo just serves as an example and shouldn't be used directly in production (no security check, for example).

## Schema

* The end-user executes the Webclient app shortcut, which opens a window where they can select the agency they want to use (each agency has a separate version of the application).
* The request goes from the client to PASOE (`server/getHash.p`), and PASOE returns the hash of the Zip file for this agency.
* The client searches in the local cache (by default in `session:temp-directory`) for a directory named as the hash.
* If the directory is present, then inject this directory into the propath and execute the application.
* Otherwise, execute `server/getFile.p` which returns the file itself as a `memptr`, then unzip it in the local cache and execute the application.

## Setup

* Compile the code of the client application (`src/main/abl` directory, except `server` subdirectory), and create a Webclient application in PDO. The desktop shortcut should execute `run.p`. The `pasoe.txt` file should contain the PASOE connection string.
* Compile the server code (`src/main/abl/server` directory), and drop it in the PASOE propath. Paths to Zip files are hardcoded in the procedures, so you'll have to modify them according to your environment.

## To Do

* Local cache cleanup (avoid having GB of old versions locally)
* Security
* Multi-modules
* UI improvement...
