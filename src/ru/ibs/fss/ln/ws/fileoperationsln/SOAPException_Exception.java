
package ru.ibs.fss.ln.ws.fileoperationsln;

import javax.xml.ws.WebFault;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.4-b01
 * Generated source version: 2.2
 *
 */
@WebFault(name = "SOAPException", targetNamespace = "http://ru/ibs/fss/ln/ws/FileOperationsLn.wsdl")
public class SOAPException_Exception
        extends Exception
{

    /**
     * Java type that goes as soapenv:Fault detail element.
     *
     */
    private SOAPException faultInfo;

    /**
     *
     * @param message
     * @param faultInfo
     */
    public SOAPException_Exception(String message, SOAPException faultInfo) {
        super(message);
        this.faultInfo = faultInfo;
    }

    /**
     *
     * @param message
     * @param faultInfo
     * @param cause
     */
    public SOAPException_Exception(String message, SOAPException faultInfo, Throwable cause) {
        super(message, cause);
        this.faultInfo = faultInfo;
    }

    /**
     *
     * @return
     *     returns fault bean: ru.ibs.fss.ln.ws.fileoperationsln.SOAPException
     */
    public SOAPException getFaultInfo() {
        return faultInfo;
    }

}
