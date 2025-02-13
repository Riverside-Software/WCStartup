block-level on error undo, throw.

define input  parameter ipOrg  as character no-undo.
define output parameter opOrg  as character no-undo.
define output parameter opHash as character no-undo.

opOrg = ipOrg.
input through value("md5sum /app/pasoe/pasoe1/openedge/proto/file" + ipOrg + ".zip | cut -d ' ' -f 1").
import unformatted opHash.
input close.
