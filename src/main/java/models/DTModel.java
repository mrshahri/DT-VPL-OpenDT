package models;

public class DTModel {
    private String dtId;
    private String dtName;
    private String dtType;
    private String dtEndpoint;
    private String dtDescription;
    private String dtPrimaryCategory;
    private String dtSecondaryCategory;
    private String scope;

    public DTModel() {
    }

    public String getDtId() {
        return dtId;
    }

    public void setDtId(String dtId) {
        this.dtId = dtId;
    }

    public String getDtName() {
        return dtName;
    }

    public void setDtName(String dtName) {
        this.dtName = dtName;
    }

    public String getDtType() {
        return dtType;
    }

    public void setDtType(String dtType) {
        this.dtType = dtType;
    }

    public String getDtEndpoint() {
        return dtEndpoint;
    }

    public void setDtEndpoint(String dtEndpoint) {
        this.dtEndpoint = dtEndpoint;
    }

    public String getDtDescription() {
        return dtDescription;
    }

    public void setDtDescription(String dtDescription) {
        this.dtDescription = dtDescription;
    }

    public String getDtPrimaryCategory() {
        return dtPrimaryCategory;
    }

    public void setDtPrimaryCategory(String dtPrimaryCategory) {
        this.dtPrimaryCategory = dtPrimaryCategory;
    }

    public String getDtSecondaryCategory() {
        return dtSecondaryCategory;
    }

    public void setDtSecondaryCategory(String dtSecondaryCategory) {
        this.dtSecondaryCategory = dtSecondaryCategory;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }
}
