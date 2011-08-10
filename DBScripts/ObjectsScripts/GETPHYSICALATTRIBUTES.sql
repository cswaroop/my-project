CREATE OR REPLACE FUNCTION getPhysicalAttributes (
p_groupNo VARCHAR2 
)
return VARCHAR2 is
    cursor cr_phyAttr          
    IS
    Select (AML.ATTRIBUTE_NAME ||':' ||PQPA.ATTRIBUTE_VALUE || ' Rejection: ' || nvl(PQPA.REJECTION,'NA')) AS PHY_ATTR
    From PQPA_PQ_PHYSICAL_ATTRIBUTES PQPA, AML_ATTRIBUTE_MASTER_LIST AML
    Where 
    PQPA.ATTRIBUTE_ID = AML.ATTRIBUTE_ID AND
    PQPA.PHY_ATTRIBUTE_GROUP_NO =p_groupNo;  
    
    qualityDescription VARCHAR2(4000) :='';   
    begin
            for phy_rec in cr_phyAttr
            loop
            qualityDescription:= qualityDescription ||' '||  phy_rec.PHY_ATTR ||' '|| chr(10);
            end loop;
            return  qualityDescription;
    end; 
/

