import { useState, useEffect, Dispatch, SetStateAction } from "react";
//others
import Button from "react-bootstrap/Button";

type PostEditProps = {
  isEdit: boolean;
  setIsEdit: Dispatch<SetStateAction<boolean>>;
};
export const PostEdit: React.FC<PostEditProps> = ({ isEdit, setIsEdit }) => {
  return (
    <>
      {!isEdit && (
        <Button variant="outline-primary" onClick={() => setIsEdit(true)}>
          Edit
        </Button>
      )}
      {isEdit && (
        <Button variant="outline-secondary" onClick={() => setIsEdit(false)}>
          Close
        </Button>
      )}
    </>
  );
};