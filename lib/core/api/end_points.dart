class EndPoints {
  static const String baseUrl = 'http://41.33.39.169:180/api/';
  static const String login = '${baseUrl}Security/Login';
  static const String externalLogin = '${baseUrl}Security/ExternalStudentLogin';
  static const String register = '${baseUrl}Security/SignUP_Profile';
  static const String getNationalities = '${baseUrl}Lookup/GetNationalitySelectAll';
  static const String getGenders = '${baseUrl}Lookup/GetGenderSelectAll';
  static const String getCampuses = '${baseUrl}Lookup/GetBranchesAPI';
  static const String getCertificationTypes = '${baseUrl}Lookup/CertificationTypeSelectAll';
  static const String getSpecializations = '${baseUrl}Lookup/SpecializationType_SelectByID';
  static const String getCertificationYears = '${baseUrl}Lookup/GetCertificationYears';
  static const String getFaculties = '${baseUrl}Lookup/FacultyByBranchAPI';
  static const String getEnrollmentStatus = '${baseUrl}Lookup/GetEnrollmentStatus';
  static const String getGovernorates = '${baseUrl}Lookup/GetGovernorate';
  static const String getCountries = '${baseUrl}Lookup/GetCountriesSelectAll';
  static const String getReligions = '${baseUrl}Lookup/GetReligionsSelectAll';
  ///Applicant
  static const String applicantViewApplication = '${baseUrl}ApplicantData/GetAllApplicantDataList';
  static const String getApplicantProfileData = '${baseUrl}ApplicantData/GetObjectOfPersonalData';
  static const String uploadApplicantProfileImage = '${baseUrl}ApplicantData/PostUpdateApplicantProfilePicture';
  static const String getAttachmentTypes = '${baseUrl}FileAttachments/FileAttachmentsTypes_SelectAll';
  static const String getApplicantAttachments = '${baseUrl}FileAttachments/FileAttachments_SelectByApplicantID';
  static const String deleteApplicantAttachment = '${baseUrl}FileAttachments/FileAttachment_Delete';
  static const String uploadApplicantAttachment = '${baseUrl}FileAttachments/FileAttachment_Insert';
  static const String getApplicantCertificate = '${baseUrl}ApplicantData/GetCerificationData';
  static const String uploadApplicantCertificate = '${baseUrl}ApplicantData/PostEducationHistoryInsert';
  static const String getPreferencesTypes = '${baseUrl}ApplicantData/GetlistOfPreferences';
  static const String getApplicantPreferences = '${baseUrl}ApplicantData/GetlistOfApplicantPreferences';
  static const String deleteApplicantPreference = '${baseUrl}ApplicantData/ApplicantApplicationsDelete';
  static const String uploadApplicantPreferences = '${baseUrl}ApplicantData/PostInsertPreference';
  static const String uploadApplicantPublicInfo = '${baseUrl}ApplicantData/PostPersonalDataMobile';
  static const String getApplicantTermsAndConditions = '${baseUrl}TermsAndCondition/GetCurrentTermAndCondition';
  static const String acceptApplicantTermsAndConditions = '${baseUrl}TermsAndCondition/PostTermAcceptInsertUpdate';
  static const String getApplicantPayments = '${baseUrl}Payments/GetApplicantPayments';
  static const String getApplicantExams = '${baseUrl}Exams/GetQualificationExams';
  static const String cancelApplicantInCampusExam = '${baseUrl}Exams/CancelInCampusExam';
  static const String uploadEquivalentExam = '${baseUrl}Exams/UpdateWillUploadEquivalentExamFile';
  static const String getAnotherTryExamNames = '${baseUrl}Exams/GetExamNames';
  static const String submitAnotherTryExam = '${baseUrl}Exams/InsertRequestedNewExamTry';
  static const String getBookExamLocations = '${baseUrl}Exams/PostExamDatesLocationsAPI';
  static const String getBookExamDates = '${baseUrl}Exams/PostApplicant_ExamDates_SelectUpComingExamDateByLocationAPI';
  static const String getBookExamTimes = '${baseUrl}Exams/PostApplicant_ExamDates_SelectByExamDateAndLocationAPI';
  static const String submitBookExamDate = '${baseUrl}Exams/BookExamDate';
  static const String getEquivalentExams = '${baseUrl}Exams/GetAllEquivalentExamTypes';
  static const String getExamCertificationFile = '${baseUrl}Exams/GetAllCertificationFileAttachment';
  static const String submitEquivalentExam = '${baseUrl}Exams/UpdateEquivalentExam';
  static const String getApplicantExamTypes = '${baseUrl}Exams/GetAllExamTypes';
  static const String submitExamTypes = '${baseUrl}Exams/ApplicantExam_UpdateExamType';
  ///Student
  static const String getAcademicYears = '${baseUrl}AcademicYear_SemesterAPI/ARG_SelectAcademicYearByStudent';
  static const String getAcademicSemesters = '${baseUrl}AcademicYear_SemesterAPI/Get_SemesterYeaByYearId';
  static const String getTranscripts = '${baseUrl}Transcript/SelectStudentTranscriptBySemester';
  static const String getSchedule = '${baseUrl}StudentSchedule/StudentSchedule';
  static const String dropStudentRegisteredCourse = '${baseUrl}StudentRegistration/DropStudentRegisteredCourse';
  static const String checkRegistrationCoRequisiteCourse = '${baseUrl}StudentRegistration/Check_Registered_CoRequisite';
  static const String returnRegisteredCourseToCart = '${baseUrl}StudentRegistration/ReturnRegisteredCourseToCartForUpdate';
  static const String getStudentPersonalInfo = '${baseUrl}AR_StudentInfo/GetStudentData';
  static const String getStudentCourses = '${baseUrl}AR_StudentCourses/GetStudentCourses';
  static const String getStudentCourseGrades = '${baseUrl}StudentGrading/GetStudentActivityGrading';
  static const String getStudentAttendanceReports = '${baseUrl}StudentAttendance/GetStudentAttendanceReport';
  static const String getStudentRegisteredCourses = '${baseUrl}StudentRegistration/StudentRegistrationCourses';
  static const String getStudentCartItems = '${baseUrl}StudentRegistration/StudentCartItems';
  static const String getStudentCustomRegisteredCourses = '${baseUrl}StudentRegistration/StudentCustomRegistrationCourses';
  static const String registerStudentAllSubjects = '${baseUrl}StudentRegistration/RegisterAll';
  static const String removeStudentCartItem = '${baseUrl}StudentRegistration/RemoveCartItem';
  static const String getStudentSingleRegisteredCourse = '${baseUrl}StudentRegistration/GetAllCourseSections';
  static const String addToCart = '${baseUrl}StudentRegistration/AddToCart';
  static const String getFacultyLevels = '${baseUrl}StudentRegistration/GetFacultyLevels';
  static const String getSpecializationLevels = '${baseUrl}StudentRegistration/GetFacultySpecializations';
  ///Financial
  ///Basic Data
  static const String getStudentBasicFinancialFees = '${baseUrl}CashReceipts/GetStudentBasicFinancialData';
  ///Cash Receipt
  static const String getStudentAccountChargesDetails = '${baseUrl}CashReceipts/GetStudentAccountDetails';
  static const String getSystemCurrencies = '${baseUrl}CashReceipts/GetCurrencies';
  static const String getStudentTransactions = '${baseUrl}CashReceipts/GetStudentTransactions';
  static const String getStudentTransactionsAdvanced = '${baseUrl}CashReceipts/GetStudentTransactionsAdvanced';
  ///Charges
  static const String getStudentCreditCharges = '${baseUrl}Charges/GetStudentCreditChargesBasic';
  static const String getStudentDebitCharges = '${baseUrl}Charges/GetStudentDebitChargesBasic';
  static const String getStudentDebitChargesAdvanced = '${baseUrl}Charges/GetStudentDebitChargesAdvanced';
  static const String getStudentCurrentScholarship = '${baseUrl}Scholarships/GetStudentCurrentScholarship';
  static const String getStudentScholarshipHistory = '${baseUrl}Scholarships/GetStudentHistoryScholarship';
  ///Student History
  static const String getStudentFinancialHistory = '${baseUrl}CashReceipts/GetStudentFinancialHistory';
  ///Guest Inquiry
  static const String getGuestInquiryFaculties = '${baseUrl}Admission/Admission_SelectAllFaculties';
  static const String getInquiryRequestTypes = '${baseUrl}LookUpInquiry/GetAllRequestTypeBYCaller';
  static const String insertInquiry = '${baseUrl}InquiryOnline/OnlineBasicDataInsert';
  static const String getInquiryEvents = '${baseUrl}MarketingEvent/EV_MarketingEvent_SelectAll';
  static const String searchOnlineInquiryRequest = '${baseUrl}IREQ_RA_Request/IREQ_Request_Select';

}