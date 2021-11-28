import React, { useContext } from "react";
import DBHelper from "../../helpers/DBHelper";


function BranchList() {
    const DBHelperCtx = useContext(DBHelper);
    function showBranch(branch) {
        return (
            <div>
                <li><a>{branch.ID}</a></li>
                <li>{branch.imageURL}</li>
                <li>{branch.address}</li>
                <li>{branch.province}</li>
                <li>{branch.email}</li>
                <li>{branch.phoneNumber}</li>
            </div>
        )
    };
    function showBranchList() {
        DBHelperCtx.fetchBranchList();
        var content = DBHelperCtx.totalItem
        ? DBHelperCtx.branchList.map(function(branch) {
            return showBranch(branch);
        }) 
        : null;
        return (
        <div>
            <div>
                <li>Branch </li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
            </div>
            <div>
                {content}
            </div>
        </div>
        );
    }
    return (
    <>
        {showBranchList()}
    </>);
}
export default BranchList;