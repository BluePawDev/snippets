$(document).ready(function() {


    // Bootstrap table export
    var $table = $('.table_export');
    $table.on('load-success.bs.table post-body.bs.table', function(e) {
        $.when($table.removeClass('hide'))
            .then(function() {
                $table.show();
            });
    }).bootstrapTable({
        exportTypes: ['csv', 'xlsx', 'excel', 'pdf'],
        exportDataType: 'all',
        exportOptions: {
            fileName: document.title,
            tableName: document.title,
            worksheetName: document.title,
            excelFileFormat: 'xlsx',
            htmlContent: false,
            exportHiddenCells: true,
            onMsoNumberFormat: false,
            pdfmake: {
                enabled: true,
                docDefinition: {
                    pageOrientation: 'landscape',
                    pageSize: 'A3',
                    pageMargins: [20, 20, 20, 20],
                    content: [{
                        table: {
                            headerRows: 1,
                            widths: "auto"
                        },
                        layout: 'lightHorizontalLines'
                    }],
                    defaultStyle: {
                        fontSize: 8
                    }
                }
            }
        }
    });


    $('#btnSearch').on('click', function() {
        var self = $(this);
        var tbl = $('#' + self.data('table'));
        tbl.bootstrapTable('refresh');
    })

})


function operateFormatter(value, row, index) {
    return [
        '<a href="/Admin/LookToBookCertificateEdit.cfm?LookToBookCertificateID=' + value + '" title="Select to edit.">',
        '<i class="far fa-edit"></i>',
        '</a> '
    ].join('')
}

function dateFormatter(value, row, index) {
    var dateParse = Date.parse(value);
    return dateParse ? dateParse.toString("MM/dd/yy") : "";
}