�
 TCUSTOMERDATA 0H  TPF0TCustomerDataCustomerDataOldCreateOrder	OnCreateCustomerDataCreateLeftTop� HeightbWidth8 TTable	CustomersActive	DatabaseNameDBDEMOS	IndexName	ByCompany	TableNameCUSTOMER.DBLeft Top TFloatFieldCustomersCustNo	FieldNameCustNo  TStringFieldCustomersCompany	FieldNameCompanySize  TStringFieldCustomersAddr1	FieldNameAddr1Size  TStringFieldCustomersAddr2	FieldNameAddr2Size  TStringFieldCustomersCity	FieldNameCitySize  TStringFieldCustomersState	FieldNameState  TStringFieldCustomersZip	FieldNameZipSize
  TStringFieldCustomersCountry	FieldNameCountry  TStringFieldCustomersPhone	FieldNamePhoneSize  TStringFieldCustomersFAX	FieldNameFAXSize  TFloatFieldCustomersTaxRate	FieldNameTaxRate  TStringFieldCustomersContact	FieldNameContact  TDateTimeFieldCustomersLastInvoiceDate	FieldNameLastInvoiceDate   TTableOrdersDatabaseNameDBDEMOS	IndexNameCustNoMasterFieldsCustNoMasterSourceCustomerSource	TableName	ORDERS.DBLefthTop TFloatFieldOrdersOrderNo	FieldNameOrderNo  TFloatFieldOrdersCustNo	FieldNameCustNoRequired	  TStringFieldOrdersCustCompany	FieldKindfkLookup	FieldNameCustCompanyLookupDataSet	CustomersLookupKeyFieldsCustNoLookupResultFieldCompany	KeyFieldsCustNoLookup	  TDateTimeFieldOrdersSaleDate	FieldNameSaleDate  TDateTimeFieldOrdersShipDate	FieldNameShipDate  TIntegerFieldOrdersEmpNo	FieldNameEmpNoRequired	  TStringFieldOrdersShipToContact	FieldNameShipToContact  TStringFieldOrdersShipToAddr1	FieldNameShipToAddr1Size  TStringFieldOrdersShipToAddr2	FieldNameShipToAddr2Size  TStringFieldOrdersShipToCity	FieldName
ShipToCitySize  TStringFieldOrdersShipToState	FieldNameShipToState  TStringFieldOrdersShipToZip	FieldName	ShipToZipSize
  TStringFieldOrdersShipToCountry	FieldNameShipToCountry  TStringFieldOrdersShipToPhone	FieldNameShipToPhoneSize  TStringFieldOrdersShipVIA	FieldNameShipVIASize  TStringFieldOrdersPO	FieldNamePOSize  TStringFieldOrdersTerms	FieldNameTermsSize  TStringFieldOrdersPaymentMethod	FieldNamePaymentMethodSize  TCurrencyFieldOrdersItemsTotal	FieldName
ItemsTotal  TFloatFieldOrdersTaxRate	FieldNameTaxRate  TCurrencyFieldOrdersFreight	FieldNameFreight  TCurrencyFieldOrdersAmountPaid	FieldName
AmountPaid   TTable	LineItemsOnCalcFieldsLineItemsCalcFieldsDatabaseNameDBDEMOSIndexFieldNamesOrderNoMasterFieldsOrderNoMasterSourceOrderSource	TableNameITEMS.DBLeft� Top TFloatFieldLineItemsOrderNo	FieldNameOrderNoVisible  TFloatFieldLineItemsItemNo	FieldNameItemNo  TFloatFieldLineItemsPartNo	FieldNamePartNo  TStringFieldLineItemsPartName	FieldKindfkLookup	FieldNamePartNameLookupDataSetPartsLookupKeyFieldsPartNoLookupResultFieldDescription	KeyFieldsPartNoSizeLookup	  TIntegerFieldLineItemsQty	FieldNameQty  TCurrencyFieldLineItemsPrice	FieldKindfkLookup	FieldNamePriceLookupDataSetPartsLookupKeyFieldsPartNoLookupResultField	ListPrice	KeyFieldsPartNoLookup	  TFloatFieldLineItemsDiscount	FieldNameDiscountDisplayFormat#0.#%
EditFormat##.#	Precision  TCurrencyFieldLineItemsTotal	FieldKindfkCalculated	FieldNameTotal
Calculated	  TCurrencyFieldLineItemsExtendedPrice	FieldKindfkCalculated	FieldNameExtendedPrice
Calculated	   TTablePartsDatabaseNameDBDEMOS	TableNamePARTS.DBLeft� Top TFloatFieldPartsPartNo	FieldNamePartNo  TFloatFieldPartsVendorNo	FieldNameVendorNo  TStringFieldPartsDescription	FieldNameDescriptionSize  TFloatFieldPartsOnHand	FieldNameOnHand  TFloatFieldPartsOnOrder	FieldNameOnOrder  TCurrencyField	PartsCost	FieldNameCost  TCurrencyFieldPartsListPrice	FieldName	ListPrice   TDataSourceCustomerSourceDataSet	CustomersLeft Top8  TDataSourceOrderSourceDataSetOrdersLefthTop8  TDataSourceLineItemSourceDataSet	LineItemsLeft� Top8  TDataSource
PartSourceDataSetPartsLeft� Top8  TQueryRepQueryDatabaseNameDBDEMOSSQL.Strings4select * from customer a, orders b, items c, parts dwhere a.custno = b.custno  and b.orderno = c.orderno  and c.partno = d.partnoorder by a.company, orderno Left Top�  TFloatFieldRepQueryCustNo	FieldNameCustNo  TStringFieldRepQueryCompany	FieldNameCompanySize  TStringFieldRepQueryAddr1	FieldNameAddr1Size  TStringFieldRepQueryAddr2	FieldNameAddr2Size  TStringFieldRepQueryCity	FieldNameCitySize  TStringFieldRepQueryState	FieldNameState  TStringFieldRepQueryZip	FieldNameZipSize
  TStringFieldRepQueryCountry	FieldNameCountry  TStringFieldRepQueryPhone	FieldNamePhoneSize  TStringFieldRepQueryFAX	FieldNameFAXSize  TFloatFieldRepQueryTaxRate	FieldNameTaxRate  TStringFieldRepQueryContact	FieldNameContact  TDateTimeFieldRepQueryLastInvoiceDate	FieldNameLastInvoiceDate  TFloatFieldRepQueryOrderNo	FieldNameOrderNo  TFloatFieldRepQueryCustNo_1	FieldNameCustNo_1  TDateTimeFieldRepQuerySaleDate	FieldNameSaleDate  TDateTimeFieldRepQueryShipDate	FieldNameShipDate  TIntegerFieldRepQueryEmpNo	FieldNameEmpNo  TStringFieldRepQueryShipToContact	FieldNameShipToContact  TStringFieldRepQueryShipToAddr1	FieldNameShipToAddr1Size  TStringFieldRepQueryShipToAddr2	FieldNameShipToAddr2Size  TStringFieldRepQueryShipToCity	FieldName
ShipToCitySize  TStringFieldRepQueryShipToState	FieldNameShipToState  TStringFieldRepQueryShipToZip	FieldName	ShipToZipSize
  TStringFieldRepQueryShipToCountry	FieldNameShipToCountry  TStringFieldRepQueryShipToPhone	FieldNameShipToPhoneSize  TStringFieldRepQueryShipVIA	FieldNameShipVIASize  TStringField
RepQueryPO	FieldNamePOSize  TStringFieldRepQueryTerms	FieldNameTermsSize  TStringFieldRepQueryPaymentMethod	FieldNamePaymentMethodSize  TCurrencyFieldRepQueryItemsTotal	FieldName
ItemsTotal  TFloatFieldRepQueryTaxRate_1	FieldName	TaxRate_1  TCurrencyFieldRepQueryFreight	FieldNameFreight  TCurrencyFieldRepQueryAmountPaid	FieldName
AmountPaid  TFloatFieldRepQueryOrderNo_1	FieldName	OrderNo_1  TFloatFieldRepQueryItemNo	FieldNameItemNo  TFloatFieldRepQueryPartNo	FieldNamePartNo  TIntegerFieldRepQueryQty	FieldNameQty  TFloatFieldRepQueryDiscount	FieldNameDiscount  TFloatFieldRepQueryPartNo_1	FieldNamePartNo_1  TFloatFieldRepQueryVendorNo	FieldNameVendorNo  TStringFieldRepQueryDescription	FieldNameDescriptionSize  TFloatFieldRepQueryOnHand	FieldNameOnHand  TFloatFieldRepQueryOnOrder	FieldNameOnOrder  TCurrencyFieldRepQueryCost	FieldNameCost  TCurrencyFieldRepQueryListPrice	FieldName	ListPrice   TDataSourceRepQuerySourceDataSetRepQueryLeft Top�   TfrDBDataSetCustomersDS
DataSourceCustomerSourceLeft Topl  TfrDBDataSetOrdersDS
DataSourceOrderSourceLefthTopl  TfrDBDataSetItemsDS
DataSourceLineItemSourceLeft� Topl  TfrDBDataSetPartDS
DataSource
PartSourceLeft� Topl  TfrDBDataSetQueryDS
DataSourceRepQuerySourceLeft Top  TTableBioDatabaseNameDBDEMOS	TableName
biolife.dbLeftlTop�   TDataSource	BioSourceDataSetBioLeftlTop�   TfrDBDataSetBioDS
DataSource	BioSourceLeftlTop  TQuery	RepQuery1DatabaseNameDBDEMOS
DataSourceCustomerSourceSQL.StringsSelect * from Orders.DBwhere CustNo = :CustNo Left� Top� 	ParamDataDataTypeftFloatNameCustNo	ParamType	ptUnknown    TDataSourceRepQuery1SourceDataSet	RepQuery1Left� Top�   TfrDBDataSetQuery1DSCloseDataSource	
DataSourceRepQuery1SourceLeft� Top  TTable
CrossTable	TableNamecrosstest.dbLeft� Top�    