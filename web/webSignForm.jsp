<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="http://192.168.2.45:999/res/js/jquery-3.2.1.min.js"></script>
    <meta charset="UTF-8">
    <title>SignAndCrypt</title>
    <script language="javascript">window.allow_firefox_cadesplugin_async=1</script>
    <script language="javascript" src="http://192.168.2.45:999/res/js/cadesplugin_api.js"></script>
    <script type="text/javascript" src="http://192.168.2.45:999/res/js/nmcades_plugin_api.js"></script>
    <script type="text/javascript" src="http://192.168.2.45:999/res/js/initcode.js"></script>
    <script type="text/javascript">
    </script>
</head>
<body>

<div id="item_border" name="CertListBoxToHide">
    <select size="4" name="CertListBox" id="CertListBox" style="width:100%;resize:none;border:0;">
    </select>
</div>

<input value="жмяк" onclick="run();" type="button">
<input id="runbtn" value="жмяк2" type="button">
<p id="info_msg" name="SignatureTitle">Подпись:</p>

<textarea id="SignThis" style="font-size:9pt;height:600px;width:100%;resize:none;border:0;">
    <%=request.getAttribute("test")%>
</textarea>

<textarea id="SignatureTxtBox" readonly="readonly" style="font-size:9pt;height:600px;width:100%;resize:none;border:0;"></textarea>
<script type="text/javascript">
    var CADESCOM_CADES_BES = 1;
    var CAPICOM_CURRENT_USER_STORE = 2;
    var CAPICOM_MY_STORE = "My";
    var CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED = 2;
    var CAPICOM_CERTIFICATE_FIND_SUBJECT_NAME = 1;
    var canPromise = !!window.Promise;
    if(isEdge()) {
        ShowEdgeNotSupported();
    } else {
        if(canPromise) {
            cadesplugin.then(function () {
                    Common_CheckForPlugIn();
                },
                function(error) {

                }
            );
        } else {
            window.addEventListener("message", function (event){
                    if (event.data == "cadesplugin_loaded") {
                        CheckForPlugIn_NPAPI('isPlugInEnabled');
                    } else if(event.data == "cadesplugin_load_error") {

                    }
                },
                false);
            window.postMessage("cadesplugin_echo_request", "*");
        }
    }

    function SignCreate(cert,dataToSign) {
        cadesplugin.async_spawn(function*(arg) {

            var e = document.getElementById(arg[0]);
            var selectedCertID = e.selectedIndex;
            if (selectedCertID == -1) {
                alert("Select certificate!!!");
                return;
            }

            var thumbprint = e.options[selectedCertID].value.split(" ").reverse().join("").replace(/\s/g, "").toUpperCase();

            try {
                var oStore = yield cadesplugin.CreateObjectAsync("CAdESCOM.Store");
                yield oStore.Open();
            } catch (err) {
                alert('Certificate not found');
                return;
            }
            var CAPICOM_CERTIFICATE_FIND_SHA1_HASH = 0;
            var all_certs = yield oStore.Certificates;
            var oCerts = yield all_certs.Find(CAPICOM_CERTIFICATE_FIND_SHA1_HASH, thumbprint);
            var certificate = yield oCerts.Item(1);

            var Signature;
            try
            {
                var errormes = "";
                try {
                    var oSigner = yield cadesplugin.CreateObjectAsync("CAdESCOM.CPSigner");
                } catch (err) {
                    errormes = "Failed to create CAdESCOM.CPSigner: " + err.number;
                    throw errormes;
                }

                if (oSigner) {
                    yield oSigner.propset_Certificate(certificate);
                }
                else {
                    errormes = "Failed to create CAdESCOM.CPSigner";
                    throw errormes;
                }

                var oSignedXML = yield cadesplugin.CreateObjectAsync("CAdESCOM.SignedXML");


                var pubKey = yield certificate.PublicKey();
                var algo = yield pubKey.Algorithm;
                //var algoOid = yield algo.Value;

                var signMethod = "http://www.w3.org/2001/04/xmldsig-more#gostr34102001-gostr3411";
                var digestMethod = "http://www.w3.org/2001/04/xmldsig-more#gostr3411";


                var CADESCOM_XML_SIGNATURE_TYPE_ENVELOPED = 2;

                if (dataToSign) {
                    // Данные на подпись ввели
                    yield oSignedXML.propset_Content(dataToSign);
                    yield oSignedXML.propset_SignatureType(CADESCOM_XML_SIGNATURE_TYPE_ENVELOPED);
                    yield oSignedXML.propset_SignatureMethod(signMethod);
                    yield oSignedXML.propset_DigestMethod(digestMethod);

                    try {
                        Signature = yield oSignedXML.Sign(oSigner);
                    }
                    catch (err) {
                        errormes = "Не удалось создать подпись из-за ошибки: " + cadesplugin.getLastError(err);
                        throw errormes;
                    }
                }
                document.getElementById("SignatureTxtBox").innerHTML = Signature;
            }
            catch(err)
            {
                document.getElementById("SignatureTxtBox").innerHTML = err;
            }

        }, cert,dataToSign); //cadesplugin.async_spawn
    }


    function run() {

        var sContent ="";
        var dataToSign = document.getElementById("SignThis").value;
        if(dataToSign==""){
            SignCreate('CertListBox', sContent);
        }else{
            SignCreate('CertListBox', dataToSign);
        }
    }

    $(document).ready(function() {

        $("#runbtn").click(function(){
            var temp = document.getElementById("SignatureTxtBox").value;
            $.ajax({
                type: "POST",
                url: "http://192.168.2.45:999/api/sign/getXML",
                crossDomain: true,
                /*  xhrFields: {
                 withCredentials: true
                 },*/
                dataType:"json",
                //contentType: "json", // NOT dataType!
                data: temp,
                //data:{action:"something"},
                scriptCharset: "utf-8",
                success: function(response) {
                    var t = "0"+ " <%=request.getContextPath()%>";
                    alert(t);
                    //alert(response[0]);
                    //alert(response[0].amount);
                    //alert(response.d.[0]);
                }
            });
        });
    });

</script>
</body>
</html>