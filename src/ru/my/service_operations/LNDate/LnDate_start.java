package ru.my.service_operations.LNDate;

import ru.my.helpers_operations.GlobalVariables;
import ru.my.helpers_operations.WorkWithXML;
import ru.my.service_operations.newLNNumRange.NewLnNumRange_start;
import ru.my.signAndCrypt.Encrypt;
import ru.my.signAndCrypt.Sign;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPMessage;

/**
 * Created by rkurbanov on 28.06.2017.
 */
public class LnDate_start {

    public static SOAPMessage Start(SOAPMessage soapMsg)
    {

        try {
            NewLnNumRange_start.Create(soapMsg);
            soapMsg= Sign.signation();
            WorkWithXML.saveSoapToXml("GetLnDate.xml", soapMsg);
            GlobalVariables.Request = WorkWithXML.soapMessageToString(soapMsg);
            MessageFactory mf = MessageFactory.newInstance();

            SOAPMessage NewMessg = mf.createMessage();
            NewMessg = Encrypt.CreateXMLAndEncrypt(NewMessg, "GetLnDate.xml");


            return NewMessg;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return soapMsg;
    }
}
