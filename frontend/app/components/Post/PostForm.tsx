import { useState, useMemo } from "react";
import { useForm } from "react-hook-form";
//Bootstrap
import Button from "react-bootstrap/Button";
import Row from "react-bootstrap/Row";
//Moudle
import { Auth } from "../../modules/Auth";
//hooks
import { useFlashReducer } from "../../hooks/useFlashReducer";
import { useFeedFetch } from "../../hooks/useFeedFetch";

//Post送信先用のUrl
const Post_Url = process.env.NEXT_PUBLIC_BASE_URL + "posts";

export const PostForm: React.FC = () => {
  //投稿画像データを所持するstate
  const [postImage, setPostImage] = useState<File>();

  //useFlashReducerを読み込み
  const { FlashReducer } = useFlashReducer();

  //useFeedFetchを読み込み
  const { reloadFetching } = useFeedFetch();

  //登校画像データのpreviewを表示
  const getPreviewPostImage = useMemo((): React.ReactElement | void => {
    if (!postImage) {
      return;
    }
    const PreviewUrl = URL.createObjectURL(postImage);
    return <img src={PreviewUrl} className="my-3" style={{ width: "100%" }} />;
  }, [postImage]);

  //写真変更のonChange
  const handleSetImage = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.files) return;
    const imageFile: File = e.target.files[0];
    setPostImage(imageFile);
  };

  //input fileをButtonで押す
  const handleClickInputFile = () => {
    const target = document.getElementById("image");
    if (!target) {
      return;
    }
    target.click();
  };

  //useForm関連メソッド
  const { register, handleSubmit } = useForm();
  const onSubmit = (value: { content: string }): void => {
    const formData = new FormData();
    formData.append("post[content]", value.content);
    if (postImage) {
      formData.append("post[image]", postImage);
    }

    const config = {
      method: "POST",
      headers: {
        Accept: "application/json",
        Authorization: `Bearer ${Auth.getToken()}`,
      },
      body: formData,
    };

    fetch(Post_Url, config)
      .then((response) => {
        if (!response.ok) {
          response.json().then((res): any => {
            if (res.hasOwnProperty("message")) {
              //authentication関連のエラー処理
              FlashReducer({ type: "DANGER", message: res.message });
            }
          });
        } else {
          return response.json();
        }
      })
      .then((data) => {
        //statusがokayでなければ、dataがundefinedになる
        if (data == undefined) {
          return;
        }
        // console.log({ data });
        // Postimageを初期化
        setPostImage(undefined);
        reloadFetching();
        FlashReducer({ type: "SUCCESS", message: data.message });
      })
      .catch((error) => {
        console.error(error);
        FlashReducer({ type: "DANGER", message: "Error" });
      });
  };

  // const onTestSubmit = (value) => {
  //   const formData = new FormData()
  //   formData.append('post[content]', value.content)
  //   formData.append('post[image]', postImage)
  //   console.log(formData.get('post[content]'))
  //   console.log(formData.get('post[image]'))
  // }

  return (
    <Row>
      <div className="mt-3 p-3" style={{ width: "100%" }}>
        <form onSubmit={handleSubmit(onSubmit)} style={{ maxWidth: "500px" }}>
          <textarea
            id="content"
            // name="content"
            placeholder="What's happening to you ?"
            style={{
              maxWidth: "500px",
              height: "100px",
              fontSize: "16px",
              width: "100%",
            }}
            className="p-2 "
            {...register("content", { required: true })}
          />
          <input
            className="my-2"
            type="file"
            accept="image/*"
            name="image"
            id="image"
            style={{ display: "none" }}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleSetImage(e)}
          />
          {getPreviewPostImage}
          <Button
            style={{ maxWidth: "300px", width: "70%" }}
            variant="outline-secondary"
            onClick={handleClickInputFile}
          >
            ファイルを選択
          </Button>

          <Button
            style={{ maxWidth: "500px", width: "100%" }}
            className="mt-3"
            variant="outline-primary"
            type="submit"
          >
            Submit
          </Button>
        </form>
      </div>
    </Row>
  );
};