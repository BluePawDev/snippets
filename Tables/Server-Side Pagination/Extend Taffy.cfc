/**
 * Certificate API List
 */
component extends="taffy.core.resource" taffy_uri="/certificates" {
    variables.certificate = new '/rr4b.cfc.LookToBookCertificate'();
    /**
     * Get the list of Certificates
     */
    public struct function get(string search = '', string sort = '', string order = '', string offset = '', string limit = '') {
        param name="arguments.lookToBookCertificateBatchID" default="";
        param name="arguments.startDate" default="";
        param name="arguments.endDate" default="";
        param name="arguments.isRedeemed" default="";
        param name="arguments.startRedeemDate" default="";
        param name="arguments.endRedeemDate" default="";
        param name="arguments.points" default="";
        param name="arguments.lookToBookCertificateSourceID" default="";
        param name="arguments.isExpired" default="";
        param name="arguments.auditStatus" default="";
        param name="arguments.certificateNumber" default="";
        param name="arguments.memberNumber" default="";
        param name="arguments.lastName" default="";
        param name="arguments.emailAddress" default="";
        param name="arguments.search" default="";
        param name="arguments.pageNumber" default="";
        param name="arguments.action" default="";

        var args = {};
        var rtn = {
            'rows':[],
            'total': val(arguments.limit),
            'totalNotFiltered': 100
        };

        args['maxrows'] = 100000;
        args['pageNumber'] = 1;

        if(len(trim(arguments.limit))){
            args['maxrows'] = val(arguments.limit);
            args['pageNumber'] = ceiling(val(arguments.offset)/val(arguments.limit)) + 1;
        }


        args['isRedeemed'] = arguments["isRedeemed"];
        args['lookToBookCertificateBatchID'] = arguments["lookToBookCertificateBatchID"];
        args['startDate'] = arguments["startDate"];
        args['endDate'] = arguments["endDate"];
        args['isRedeemed'] = arguments["isRedeemed"];
        args['startRedeemDate'] = arguments["startRedeemDate"];
        args['endRedeemDate'] = arguments["endRedeemDate"];
        args['points'] = arguments["points"];
        args['lookToBookCertificateSourceID'] = arguments["lookToBookCertificateSourceID"];
        args['isExpired'] = arguments["isExpired"];
        args['auditStatus'] = arguments["auditStatus"];
        args['certificateNumber'] = arguments["certificateNumber"];
        args['memberNumber'] = arguments["memberNumber"];
        args['lastName'] = arguments["lastName"];
        args['emailAddress'] = arguments["emailAddress"];
        args['search'] = arguments["search"];
        args['pageNumber'] = val(arguments["pageNumber"]);
        args['action'] = arguments["action"];

        if(len(trim(arguments.sort))){
            switch (lcase(arguments.sort)) {
                case 'DateCreated':
                    arguments.sort = "L.DateCreated"
                    break;
                case 'CertificateNumber':
                    arguments.sort = "L.LookToBookCertificateID"
                    break;
                case 'points':
                    arguments.sort = "L.Points"
                    break;
                case 'RedeemDate':
                    arguments.sort = "L.RedeemDate"
                    break;
                case 'ExpirationDate':
                    arguments.sort = "B.ExpirationDate"
                    break;
                case 'FirstName':
                    arguments.sort = "L.FirstName"
                    break;
                case 'LastName':
                    arguments.sort = "L.LastName"
                    break;
                case 'EmailAddress':
                    arguments.sort = "L.EmailAddress"
                    break;
                case 'MemberNumber':
                    arguments.sort = "L.MemberNumber"
                    break;
                case 'Country':
                    arguments.sort = "L.Country"
                    break;
                case 'Source':
                    arguments.sort = "S.Source"
                    break;
                case 'AuditStatus':
                    arguments.sort = "S.Source"
                    break;
                default:
            }
            args['orderBy'] = arguments.sort & ' ' & arguments.order;
        }

        var qry = variables.certificate.getLookToBookCertificatePagination( argumentCollection = args );
        rtn.rows = queryToArray(qry);
        rtn.total = arrayLen(rtn.rows);
        rtn.totalNotFiltered = val(qry.totalRows);

        return representationOf( rtn ).withStatus(200);
    }
}