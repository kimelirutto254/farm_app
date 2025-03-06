class Farmer {
  int? checklistComplete;
  String? residentialArea;
  int? userId;
  int? companyId;
  String? signature;
  int? idNumber;
  String? householdSize;
  String? phoneNumber;
  String firstName;
  String? name;
  String? middleName;
  String? lastName;
  String? dob;
  String gender;
  String growerId;
  int isActive;
  int createdBy;
  String? createdAt;
  String? updatedAt;
  String? region;
  String? farmSize;
  String? productionArea;
  String? conservationArea;
  String? farmerType;
  String? town;
  String route;
  String collectionCenter;
  String nearestCenter;
  String? status;
  String? creationStatus;
  int? inspectorId;
  int? approverId;
  String permanentMaleWorkers;
  String permanentFemaleWorkers;
  String temporaryMaleWorkers;
  String temporaryFemaleWorkers;
  String leasedLand;
  String inspectionStatus;
  String? sanctionedStatus;
  String? sanctionDate;
  String? inspectionDate;
  String? buyingCenter;
  String? leased;
  String? otherCropsArea;
  int? updatedBy;

  // Constructor
  Farmer({
    this.checklistComplete,
    this.residentialArea,
    this.userId,
    this.companyId,
    this.signature,
    this.idNumber,
    this.householdSize,
    this.phoneNumber,
    required this.firstName,
    this.name,
    this.middleName,
    this.lastName,
    this.dob,
    required this.gender,
    required this.growerId,
    required this.isActive,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.region,
    this.farmSize,
    this.productionArea,
    this.conservationArea,
    this.farmerType,
    this.town,
    required this.route,
    required this.collectionCenter,
    required this.nearestCenter,
    this.status,
    this.creationStatus,
    this.inspectorId,
    this.approverId,
    this.permanentMaleWorkers = "0",
    this.permanentFemaleWorkers = "0",
    this.temporaryMaleWorkers = "0",
    this.temporaryFemaleWorkers = "0",
    required this.leasedLand,
    this.inspectionStatus = "Not Inspected",
    this.sanctionedStatus,
    this.sanctionDate,
    this.inspectionDate,
    this.buyingCenter,
    this.leased,
    this.otherCropsArea,
    this.updatedBy,
  });

  // Factory method to create a Farmer from a map (JSON)
  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      checklistComplete: json['checklist_complete'],
      residentialArea: json['residential_area'],
      userId: json['user_id'],
      companyId: json['company_id'],
      signature: json['signature'],
      idNumber: json['id_number'],
      householdSize: json['household_size'],
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      name: json['name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      dob: json['dob'],
      gender: json['gender'].toLowerCase(),
      growerId: json['grower_id'],
      isActive: json['is_active'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      region: json['region'],
      farmSize: json['farm_size'],
      productionArea: json['production_area'],
      conservationArea: json['conservation_area'],
      farmerType: json['farmer_type'],
      town: json['town'],
      route: json['route'],
      collectionCenter: json['collection_center'],
      nearestCenter: json['nearest_center'],
      status: json['status'],
      creationStatus: json['creation_status'],
      inspectorId: json['inspector_id'],
      approverId: json['approver_id'],
      permanentMaleWorkers: json['permanent_male_workers'] ?? "0",
      permanentFemaleWorkers: json['permanent_female_workers'] ?? "0",
      temporaryMaleWorkers: json['temporary_male_workers'] ?? "0",
      temporaryFemaleWorkers: json['temporary_female_workers'] ?? "0",
      leasedLand: json['leased_land'],
      inspectionStatus: json['inspection_status'] ?? "Not Inspected",
      sanctionedStatus: json['sanctioned_status'],
      sanctionDate: json['sanction_date'],
      inspectionDate: json['inspection_date'],
      buyingCenter: json['buying_center'],
      leased: json['leased'],
      otherCropsArea: json['other_crops_area'],
      updatedBy: json['updated_by'],
    );
  }

  // Method to convert a Farmer object to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'checklist_complete': checklistComplete,
      'residential_area': residentialArea,
      'user_id': userId,
      'company_id': companyId,
      'signature': signature,
      'id_number': idNumber,
      'household_size': householdSize,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'name': name,
      'middle_name': middleName,
      'last_name': lastName,
      'dob': dob,
      'gender': gender,
      'grower_id': growerId,
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'region': region,
      'farm_size': farmSize,
      'production_area': productionArea,
      'conservation_area': conservationArea,
      'farmer_type': farmerType,
      'town': town,
      'route': route,
      'collection_center': collectionCenter,
      'nearest_center': nearestCenter,
      'status': status,
      'creation_status': creationStatus,
      'inspector_id': inspectorId,
      'approver_id': approverId,
      'permanent_male_workers': permanentMaleWorkers,
      'permanent_female_workers': permanentFemaleWorkers,
      'temporary_male_workers': temporaryMaleWorkers,
      'temporary_female_workers': temporaryFemaleWorkers,
      'leased_land': leasedLand,
      'inspection_status': inspectionStatus,
      'sanctioned_status': sanctionedStatus,
      'sanction_date': sanctionDate,
      'inspection_date': inspectionDate,
      'buying_center': buyingCenter,
      'leased': leased,
      'other_crops_area': otherCropsArea,
      'updated_by': updatedBy,
    };
  }
}
