import { useState, useEffect } from "react";
import Head from "next/head";
import { useRouter } from "next/router";
import Link from "next/link";
import TimeAgo from "react-timeago";
//components
import { Layout } from "../../../components/Layout";
import { External_Image } from "../../../components/External_Image";
import { PostDelete } from "../../../components/Post/PostDelete";
//types
import { PostType } from "../../../types/Post";
//others
import Card from "react-bootstrap/Card";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
type InstantUserType = {
  id: number;
  name: string;
  gravator_url: string;
};
type postDate = {
  post: PostType;
  user: InstantUserType;
};

const PostShow: React.FC = () => {
  //state一覧
  const [data, setData] = useState<postDate>();

  //router機能を設定
  const router = useRouter();
  const { id } = router.query;

  //IDからpostのデータを取得
  const PostShowUrl = process.env.NEXT_PUBLIC_BASE_URL + "posts/" + id;
  //profileのユーザー情報を取得
  useEffect(
    function () {
      if (id === undefined) {
        return;
      }
      fetch(PostShowUrl, {
        headers: {
          "Content-Type": "application/json",
        },
      })
        .then((res) => res.json())
        .then((data) => {
          console.log({ data });
          setData(data);
        });
    },
    [id]
  );

  return (
    <Layout>
      <Head>
        <title>Post{id} | Sample App</title>
      </Head>
      {data && (
        <Card className="my-3 mx-auto" border="secondary" style={{ maxWidth: "900px" }}>
          <Card.Body className="p-1">
            <Container>
              <Row>
                <Col sm={2} md={2} lg={2} className="pl-2">
                  <External_Image
                    src={data.user.gravator_url}
                    alt="User icon"
                    width={50}
                    height={50}
                    className="rounded-circle"
                  />
                </Col>
                <Col sm={10} md={10} lg={10}>
                  <Link href={`/users/${data.user.id}`}>
                    <p className="text-primary mb-1 hover" role="button">
                      {data.user.name}
                    </p>
                  </Link>

                  <p className="mb-1">{data.post.content}</p>
                </Col>
              </Row>
              {/* 投稿に写真があれば表示 */}
              {data.post.image_url && (
                <Row className="justify-content-center mb-3">
                  <External_Image
                    src={data.post.image_url}
                    alt="Post Image"
                    width={200}
                    height={200}
                    className="mx-auto"
                  />
                </Row>
              )}
            </Container>
            <footer className="blockquote-footer py-2 my-0 mx-auto" style={{ width: "80%" }}>
              Posted <TimeAgo date={new Date(data.post.created_at)} />
              <span className="float-right">
                <PostDelete id={data.post.id} />
              </span>
            </footer>
          </Card.Body>
        </Card>
      )}
    </Layout>
  );
};

export default PostShow;