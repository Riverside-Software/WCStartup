block-level on error undo, throw.

define input  parameter ipOrg  as character no-undo.
define input  parameter ipHash as character no-undo.
define output parameter opOrg  as character no-undo.
define output parameter opHash as character no-undo.
define output parameter opFile as memptr    no-undo.

opOrg = ipOrg.
opHash = ipHash.
copy-lob from file "/app/pasoe/pasoe1/openedge/proto/file" + ipOrg + ".zip" to opFile.
