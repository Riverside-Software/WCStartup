 
 /*------------------------------------------------------------------------
    File        : Form1
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : 
    Created     : 
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.Form.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Form1 INHERITS Form: 
	
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE comboBox1 AS System.Windows.Forms.ComboBox NO-UNDO.
	DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    def private var zz as handle no-undo.
		
	CONSTRUCTOR PUBLIC Form1 (  ):
        create server zz.
        InitializeComponent().
        THIS-OBJECT:ComponentsCollection:Add(THIS-OBJECT:components).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.

	END CONSTRUCTOR.

	METHOD PRIVATE VOID InitializeComponent(  ):
		
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE resources AS Progress.Util.ResourceManager NO-UNDO.
        resources = NEW Progress.Util.ResourceManager("Form1").
        THIS-OBJECT:comboBox1 = NEW System.Windows.Forms.ComboBox().
        THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* comboBox1 */
        /*  */
        THIS-OBJECT:comboBox1:FlatStyle = System.Windows.Forms.FlatStyle:Flat.
        THIS-OBJECT:comboBox1:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        THIS-OBJECT:comboBox1:FormattingEnabled = TRUE.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS System.Object EXTENT 4 NO-UNDO.
        arrayvar0[1] = "131".
        arrayvar0[2] = "691".
        arrayvar0[3] = "751".
        arrayvar0[4] = "754".
        THIS-OBJECT:comboBox1:Items:AddRange(arrayvar0).
        THIS-OBJECT:comboBox1:Location = NEW System.Drawing.Point(10, 35).
        THIS-OBJECT:comboBox1:Name = "comboBox1".
        THIS-OBJECT:comboBox1:Size = NEW System.Drawing.Size(151, 23).
        THIS-OBJECT:comboBox1:TabIndex = 0.
        THIS-OBJECT:comboBox1:Text = "131".
        /*  */
        /* button1 */
        /*  */
        THIS-OBJECT:button1:Location = NEW System.Drawing.Point(200, 25).
        THIS-OBJECT:button1:Name = "button1".
        THIS-OBJECT:button1:Size = NEW System.Drawing.Size(50, 50).
        THIS-OBJECT:button1:TabIndex = 1.
        THIS-OBJECT:button1:Text = "Start".
        THIS-OBJECT:button1:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:button1:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:button1:Click:Subscribe(THIS-OBJECT:BtnClick).
        /*  */
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(10, 10).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(100, 23).
        THIS-OBJECT:label1:TabIndex = 2.
        THIS-OBJECT:label1:Text = "Code organisme".
        THIS-OBJECT:label1:UseCompatibleTextRendering = TRUE.
        /*  */
        /* Form1 */
        /*  */
        THIS-OBJECT:ClientSize = NEW System.Drawing.Size(300, 150).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:label1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:button1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:comboBox1).
        THIS-OBJECT:Icon = CAST(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        THIS-OBJECT:MaximizeBox = FALSE.
        THIS-OBJECT:Name = "Form1".
        THIS-OBJECT:Text = "GRH".
        // THIS-OBJECT:TopMost = TRUE.
        THIS-OBJECT:ResumeLayout(FALSE).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
	END METHOD.

	DESTRUCTOR PUBLIC Form1 ( ):

	END DESTRUCTOR.

    @VisualDesigner.
    METHOD PRIVATE VOID BtnClick( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
        if (not zz:connected()) then do:
            zz:connect("-URL http://vldsoapp01-pg-grh-all-d1.app.si.test-cnaf.info:8090/webappBOI/apsv").
          // zz:connect("-URL https://pasoe.rssw.eu/apsv -servername pasoe.rssw.eu").
        end.
         
        run proto/getHash.p on server zz 
          asynchronous event-handler 'hashOk'
          (input THIS-OBJECT:comboBox1:Text, output cOrg as character, output cHash as character).
        
        
    END METHOD.

    method public void hashOk(input cOrg as character, input cHash as character):

        file-info:file-name = session:temp-directory + "\grh\" + chash.
        //message "hash " + file-info:file-name + " --" + file-info:file-type.
        if (index(file-info:file-type, 'd') > 0) then do:
            propath = file-info:full-pathname + "," + propath.
            run mainwin.r.
        end.
        else do:
          def var m1 as memptr.
          def var x1 as char.
          def var x2 as char.
            if (not zz:connected()) then do:
                zz:connect("-URL http://vldsoapp01-pg-grh-all-d1.app.si.test-cnaf.info:8090/webappBOI/apsv").
              // zz:connect("-URL https://pasoe.rssw.eu/apsv -servername pasoe.rssw.eu").
            end.

          run proto/getFile.p on server zz 
           asynchronous event-handler 'dlOk'
           (input cOrg, input cHash, output x1, output x2, output m1).
           session:set-wait-state("GENERAL").
        end.
    end method.
    
    method public void dlOk(input x1 as char, input x2 as char, input m1 as memptr):
        // message "DL OK: " + x1 + " -- " + x2 view-as alert-box.
        os-create-dir value(session:temp-dir + "\grh" ).
        copy-lob m1 to file session:temp-dir + "\grh\" + x1 + ".zip".
        set-size(m1) = 0.
        System.IO.Compression.ZipFile:extractToDirectory(session:temp-dir + "\grh\" + x1 + ".zip", session:temp-dir + "\grh\" + x2 ).
        session:set-wait-state("").
        propath = session:temp-dir + "\grh\" + x2 + "," + propath.
        run mainwin.r.
    end method.

END CLASS.
