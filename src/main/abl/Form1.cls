using Progress.Lang.*.
using Progress.Windows.Form.

block-level on error undo, throw.

class Form1 inherits Form: 
  
  define private variable button1 as System.Windows.Forms.Button no-undo.
  define private variable comboBox1 as System.Windows.Forms.ComboBox no-undo.
  define private variable components as System.ComponentModel.IContainer no-undo.
  define private variable label1 as System.Windows.Forms.Label no-undo.
  define private var srvHdl as handle no-undo.
  define private variable pasoeURL as character no-undo.

  constructor public Form1 (  ):
    create server srvHdl.
    InitializeComponent().
    this-object:ComponentsCollection:Add(this-object:components).
    input from 'pasoe.txt'.
    import unformatted pasoeURL.
    input close.
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
  end constructor.

  method private void InitializeComponent(  ):
    
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("Form1").
        this-object:comboBox1 = new System.Windows.Forms.ComboBox().
        this-object:button1 = new System.Windows.Forms.Button().
        this-object:label1 = new System.Windows.Forms.Label().
        this-object:SuspendLayout().
        /*  */
        /* comboBox1 */
        /*  */
        this-object:comboBox1:FlatStyle = System.Windows.Forms.FlatStyle:Flat.
        this-object:comboBox1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        this-object:comboBox1:FormattingEnabled = true.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Object extent 4 no-undo.
        arrayvar0[1] = "131".
        arrayvar0[2] = "691".
        arrayvar0[3] = "751".
        arrayvar0[4] = "754".
        this-object:comboBox1:Items:AddRange(arrayvar0).
        this-object:comboBox1:Location = new System.Drawing.Point(10, 35).
        this-object:comboBox1:Name = "comboBox1".
        this-object:comboBox1:Size = new System.Drawing.Size(151, 23).
        this-object:comboBox1:TabIndex = 0.
        this-object:comboBox1:Text = "131".
        /*  */
        /* button1 */
        /*  */
        this-object:button1:Location = new System.Drawing.Point(200, 25).
        this-object:button1:Name = "button1".
        this-object:button1:Size = new System.Drawing.Size(50, 50).
        this-object:button1:TabIndex = 1.
        this-object:button1:Text = "Start".
        this-object:button1:UseCompatibleTextRendering = true.
        this-object:button1:UseVisualStyleBackColor = true.
        this-object:button1:Click:Subscribe(this-object:BtnClick).
        /*  */
        /* label1 */
        /*  */
        this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        this-object:label1:Location = new System.Drawing.Point(10, 10).
        this-object:label1:Name = "label1".
        this-object:label1:Size = new System.Drawing.Size(100, 23).
        this-object:label1:TabIndex = 2.
        this-object:label1:Text = "Code organisme".
        this-object:label1:UseCompatibleTextRendering = true.
        /*  */
        /* Form1 */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(300, 150).
        this-object:Controls:Add(this-object:label1).
        this-object:Controls:Add(this-object:button1).
        this-object:Controls:Add(this-object:comboBox1).
        this-object:Icon = cast(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        this-object:MaximizeBox = false.
        this-object:Name = "Form1".
        this-object:Text = "GRH".
        // THIS-OBJECT:TopMost = TRUE.
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
  end method.

  destructor public Form1 ( ):
    //
  end destructor.

  @VisualDesigner.
  method private void BtnClick( input sender as System.Object, input e as System.EventArgs ):
    if (not srvHdl:connected()) then do:
      srvHdl:connect(pasoeURL).
    end.

    
    run server/getHash.p on server srvHdl 
        asynchronous event-handler 'hashOk'
        (input this-object:comboBox1:Text, output cOrg as character, output cHash as character).

  end method.

  method public void hashOk(input cOrg as character, input cHash as character):
    def var m1 as memptr no-undo.
    def var x1 as char no-undo.
    def var x2 as char no-undo.

    // Test if package is available in local cache
    file-info:file-name = session:temp-directory + "\wccache\" + cHash.
    if (index(file-info:file-type, 'd') > 0) then do:
      propath = file-info:full-pathname + "," + propath.
      // Execute entrypoint of cached package
      run mainwin.r.
    end.
    else do: // Otherwise download package from PASOE instance
      if (not srvHdl:connected()) then do:
        srvHdl:connect(pasoeURL).
      end.
  
      run server/getFile.p on server srvHdl 
          asynchronous event-handler 'dlOk'
          (input cOrg, input cHash, output x1, output x2, output m1).

      session:set-wait-state("GENERAL").
    end.

  end method.
    
  method public void dlOk(input cOrg as char, input cHash as char, input m1 as memptr):
    // Create cache directory in case it's not available yet
    os-create-dir value(session:temp-dir + "\wccache" ).
    // Then store Zip file
    copy-lob m1 to file session:temp-dir + "\wccache\" + cOrg + ".zip".
    set-size(m1) = 0.
    // Easy way using .Net to uncompress Zip file
    System.IO.Compression.ZipFile:extractToDirectory(session:temp-dir + "\wccache\" + cOrg + ".zip", session:temp-dir + "\grh\" + cHash).
    session:set-wait-state("").
    // Change propath and execute entrypoint
    propath = session:temp-dir + "\wccache\" + cHash + "," + propath.
    run mainwin.r.
  end method.

end class.
