import 'UIModel.dart';

void main() {
  /*Generate Condition*/
  bool generateEnglishClassNameAndQueries = false;

  if (generateEnglishClassNameAndQueries == false) {
    List lists = [
      "Date of registration",
      "Farmer Code",
      "First name",
      "Other name",
      "Member of a Coffee Organization / Cooperative?",
      "NO",
      "YES",
      "Name of Organization / Cooperative",
      "Address of Organization / Cooperative",
      "Name of owner of the land",
      "Address of owner of the land",
      "Date of Birth",
      "Age",
      "Gender",
      "National ID",
      "NIN",
      "Farmer photo",
      "Address",
      "Country",
      "District",
      "Subcounty/Division",
      "Parish/Ward",
      "Village/Cell",
      "Email",
      "Phone number",
      "Mobile money number",
      "Marital status",
      "Is the farmer certified?",
      "If yes, which scheme?",
      "Head of the family",
      "Total number of household members",
      "Total Adults in family (above 18 years)",
      "Total no of children in the family (below 18 years)",
      "Coffee farm equipments",
      "Post harvest facilities",
      "Land Tenure system",
      "Coffee type",
      "Level of education",
      "Total land owned by the farmer (ha)",
      "Total number of farms",
      "Insurance information",
      "Health Insurance",
      "If yes, Name of the company",
      "Amount",
      "Period (How long)",
      "Farm enterprise insurance",
      "If yes, Name of the crop/entity",
      "Amount",
      "Farm name",
      "Farm photo",
      "Type",
      "Varieties",
      "Spacing of coffee trees",
      "Total coffee acreage",
      "GPS location",
      "Proposed coffee planting area (acres)",
      "Average age of trees",
      "Number of shade trees",
      "Types of Shade trees",
      "Number of Unproductive trees",
      "Yield estimate/tree",
      "Good agricultural practices (GAP'S)/Business management practices (BMP'S)",
      "Other inter crops/Livestock",
      "land ownership",
      "Land topography",
      "Land Gradient",
      "Access road",
      "Altitude (in meters)",
      "Certification program",
      "Plantation date (Average)",
      "Other crops grown on the farm",
      "Pruning Date",
      "Soil and irrigation section",
      "Soil type & Texture",
      "Fertility Status",
      "Irrigation Source",
      "Method of irrigation",
      "Water harvesting method"

       ];

    List<UImodel2> langCodeGener = [];

    String tenantID = "doselva";
    String langQry = "en";

    /*ClassName Generations Declaration*/
    String labelDeclrSuffixString = "Lbl";
    String labelString = "";
    String suffixString = "Cls";
    String className = "";
    String labelDeclrString = "";

    /*Query Generations Declaration*/
    /*generate Query Validations*/
    bool generateQueries = false;

    for (int k = 0; k < lists.length; k++) {
      labelString = lists[k].toString();
      /*Split label sentence into list of string*/
      List<String> labelWordLists = lists[k].split(' ').toList();

      /*Check label words counts*/
      if (labelWordLists.length > 1) {
        String stringsMany = "";

        /*Label contains more than one word*/
        labelWordLists.forEach((labelWord) {
          String subStringedWord = "";
          /*Now we need to sub string the label words if to 2 characters*/
          /*Here if the word character length is less than 2, we avoid it*/
          /*Check label word length*/
          if (labelWord.length > 2) {
            /*Sub string the word to 2 characters*/
            subStringedWord = labelWord.substring(0, 2);
          } else {
            subStringedWord = labelWord;
          }
          /*Add all subStringedWord to one prefixString*/
          stringsMany = stringsMany + subStringedWord;
        });

        String finalWord =
            stringsMany[0].toLowerCase() + stringsMany.substring(1);
        labelDeclrString = finalWord + labelDeclrSuffixString;
        className = finalWord + suffixString;

        /*Save*/
        langCodeGener.add(UImodel2(labelString, className, labelDeclrString));
      } else {
        String prefixString = "";

        /*Label contains single word*/
        if (labelWordLists[0].length > 3) {
          /*Sub string the word to 2 characters*/
          prefixString = labelWordLists[0].substring(0, 3);
          String stringCases =
              prefixString[0].toLowerCase() + prefixString.substring(1);
          className = stringCases + suffixString;
          labelDeclrString = stringCases + labelDeclrSuffixString;

          /*Save*/
          langCodeGener.add(UImodel2(labelString, className, labelDeclrString));
        } else {
          prefixString = labelWordLists[0];
          String stringCases =
              prefixString[0].toLowerCase() + prefixString.substring(1);
          className = stringCases + suffixString;
          labelDeclrString = stringCases + labelDeclrSuffixString;

          /*Save*/
          langCodeGener.add(UImodel2(labelString, className, labelDeclrString));
        }
      }

      if (lists.length == (k + 1)) {
        generateQueries = true;
        /*print("DONE");*/
      }
    }

    if (generateQueries) {
      /*Insert Queries*/

      print("\n****************** INSERT QUERIES *****************\n");

      langCodeGener.forEach((element) {
        String labelName = element.name;
        String className = element.value;
        print(
            'insert into labelNamechange(tenantID,labelName,lang,className) values("$tenantID","$labelName","$langQry","$className");');
      });

      /*Label Declarations*/

      print("\n****************** LABEL DECLARATION *****************\n");

      String finalDecl = "";
      for (int q = 0; q < langCodeGener.length; q++) {
        String labelName = langCodeGener[q].name;
        String className = langCodeGener[q].value;
        String labelDeclName = langCodeGener[q].value2;

        finalDecl = finalDecl + "$labelDeclName = '$labelName', ";
      }
      print("String $finalDecl;");

      /*Translation switch cases*/

      print(
          "\n****************** TRANSLATION FUNC SWITCH CASES *****************\n");

      langCodeGener.forEach((element) {
        String labelName = element.name;
        String className = element.value;
        String labelDeclName = element.value2;

        print(
            " case '$className':\n setState(() { \n $labelDeclName = labelName; \n }); \n break; ");
      });

      /*ENGLISH LABEL NAME WITH RESPECTIVE CLASS*/

      print(
          "\n****************** ENGLISH LABEL NAME WITH RESPECTIVE CLASS ******************\n****************** PLEASE ADD TRANSLATED LABEL AT END (WITHOUT A SPACE BEFORE IT) ******************\n");

      for (int lC = 0; lC < langCodeGener.length; lC++) {
        String labelName = langCodeGener[lC].name;
        String className = langCodeGener[lC].value;

        print("'$className--$labelName--',");
      }
    }
  }
  else {
    List lists = ['deofthfaCls--Detail of the farmer--Detalle del granjero',
'plofreCls--Place of registration--Lugar de inscripción',
'redainCls--Registration dates interval--Intervalo de fechas de inscripción',
'facoCls--Farmer code--Código de granjero',
'iscefaCls--Is certification farmer?--¿La certificación es agricultor?',
'sCnaCls--SCI name--Nombre del SCI',
'sCcoCls--SCI code--Código SCI',
'tyofceCls--Type of certification--Tipo de certificación',
'beinanGoScCls--Beneficiary in any Gob. Scheme--Beneficiario en cualquier Gob. Esquema',
'scnaCls--Scheme name--Nombre del esquema',
'goDeCls--Government Department--Departamento de Gobierno',
'peinCls--Personal information--Informacion personal',
'fanaCls--Farmer name--Nombre del granjero',
'fanaCls--Father\'s name--Nombre del Padre',
'surCls--Surname--Apellido',
'genCls--Gender--Género',
'daofBiCls--Date of Birth--Fecha de nacimiento',
'faphCls--Farmer photo--foto de granjero',
'eduCls--Education--Educación',
'mastCls--Marital status--Estado civil',
'idteCls--Identification test--Prueba de Identificación',
'idtephCls--Identification test photo--Foto de prueba de identificación',
'catCls--Category--Categoría',
'adcanuCls--Adhaar card number--Número de tarjeta Adhaar',
'relCls--Religion--Religión',
'kioffaCls--Kind of family--Tipo de Familia',
'coinCls--Contact information--Información del contacto',
'faadCls--Farmer\'s address--Dirección del agricultor',
'mophnuCls--Mobile phone number--Número de teléfono móvil',
'emaCls--Email--Correo electrónico',
'couCls--Country--País',
'conCls--Condition--Estado',
'disCls--District--Distrito',
'talCls--Taluk--Taluk',
'vilCls--Village--Aldea',
'cluCls--Cluster--Grupo',
'puinthgrCls--Put in the group--Puesto en el Grupo',
'fPGrCls--FPO/FG Group--Grupo FPO/FG',
'phnuCls--Phone number--Número de teléfono',
'lodeCls--Loan details--Detalles del préstamo',
'lotalayeCls--Loan taken last year--Préstamo tomado el año pasado',
'lotafrCls--Loan taken from--Préstamo tomado de',
'amoCls--Amount--Monto',
'goaCls--Goal--Objetivo',
'inraCls--Interest rate(%)--Tasa de interés(%)',
'peofinCls--Period of interest--Período de interés',
'secCls--Security--Seguridad',
'loreamCls--Loan refund amount--Monto de reembolso del préstamo',
'loredaCls--Loan refund date--Fecha de reembolso del préstamo',
'bainCls--Bank information--Información bancaria',
'actyCls--Account type--Tipo de cuenta',
'acnuCls--Account number--Número de cuenta',
'naofthbaCls--Name of the bank--Nombre del banco',
'deofthbrCls--Details of the branch--Detalles de la sucursal',
'iFCoCls--IFSC/Classification Code--IFSC/Código de clasificación',
'ininCls--Insurance information--Información del seguro',
'liinCls--Life insurance--Seguro de vida',
'liInAmCls--Life Insurance Amount--Monto del seguro de vida',
'heinCls--Health insurance--Seguro de salud',
'crinCls--Crop insurance--Seguro de cultivos',
    ];

    String tenantID = "doselva";
    String langQry = "es";

    /*Insert Queries*/
    print(
        "\n****************** TRANSLATED LABEL INSERT QUERIES *****************\n");

    for (int k = 0; k < lists.length; k++) {
      String listElement = lists[k].toString();

      /*Split -- between strings*/
      List<String> stringElementSplitted = listElement.split('--').toList();

      /*ClassName*/
      String className = stringElementSplitted[0];
      /*Translated Label*/
      String translatedLabel = stringElementSplitted[2];

      print(
          'insert into labelNamechange(tenantID,labelName,lang,className) values("$tenantID","$translatedLabel","$langQry","$className");');
    }
  }
}
