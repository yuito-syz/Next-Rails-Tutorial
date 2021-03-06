import { useEffect, useMemo } from "react";
import Head from "next/head";
import Link from "next/link";
import { useRecoilValue } from "recoil";
import InfiniteScroll from "react-infinite-scroller";
//components
import { Layout } from "../components/Layout";
import { Modal } from "../components/Modal/Modal";
import { External_Image } from "../components/External_Image";
import { PostCard } from "../components/Post/PostCard";
import { PostForm } from "../components/Post/PostForm";
import { UserRelationshipModal } from "../components/Users/UserRelationshipModal";
//Bootstrap
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Spinner from "react-bootstrap/Spinner";
//Atom
import { FeedStatusAtom, FeedContentAtom } from "../Atoms/FeedAtom";
//Moudle
import { Auth } from "../modules/Auth";
//hooks
import { useUserSWR } from "../hooks/useUserSWR";
import { useFlashReducer } from "../hooks/useFlashReducer";
import { useFeedFetch } from "../hooks/useFeedFetch";

export default function Home() {
  //useFlashReducerを読み込み
  const { FlashReducer } = useFlashReducer();

  //ユーザー情報をHookから読み込み
  const { user_data } = useUserSWR();

  //FeedのAtomを読み込み
  const FeedStatus = useRecoilValue(FeedStatusAtom);
  const FeedContent = useRecoilValue(FeedContentAtom);

  //useFeedFetchを読み込み
  const { handleFetching, isHavingPosts } = useFeedFetch();

  const FeedScrollList = useMemo(() => {
    return (
      <>
        {FeedContent && isHavingPosts() && (
          <section>
            <ul className="posts">
              {FeedContent.posts.map((post) => (
                <li key={post.id} id={`post-${post.id}`}>
                  <PostCard post={post} gravator_url={post.gravator_url} name={post.name} />
                </li>
              ))}
            </ul>
          </section>
        )}
      </>
    );
  }, [FeedContent]);

  const loader = <Spinner animation="border" variant="primary" />;

  // Login時に初回のFetching
  useEffect(() => {
    if (Auth.isLoggedIn()) {
      handleFetching();
    }
  }, [Auth.isLoggedIn()]);

  return (
    <>
      <Layout>
        <Head>
          <title>Sample App</title>
          <link rel="icon" href="/favicon.ico" />
        </Head>

        {/* {Auth.isLoggedIn() && user_data.user.activated && ( */}
        {Auth.isLoggedIn() && user_data?.user?.activated && (
          <Container>
            <Row>
              <Col md={5}>
                <Container>
                  <Row>
                    <Col sm={4} md={4}>
                      <External_Image
                        alt="User icon"
                        src={user_data.user.gravator_url}
                        width={70}
                        height={70}
                      />
                    </Col>
                    <Col sm={4} md={8}>
                      <div className="align-baseline">
                        <h5 className="text-secondary mb-1">{user_data.user.name}</h5>
                        <Link href={`users/${user_data.user.id}`}>
                          <a>View my profile</a>
                        </Link>
                      </div>
                    </Col>
                  </Row>
                  <UserRelationshipModal user_id={user_data.user.id} />
                  <PostForm />
                </Container>
              </Col>
              <Col md={7}>
                <InfiniteScroll
                  loadMore={() => handleFetching()}
                  hasMore={!FeedStatus.FinishLoading}
                  loader={loader}
                >
                  {FeedScrollList}
                </InfiniteScroll>
              </Col>
            </Row>
          </Container>
        )}

        {!Auth.isLoggedIn() && (
          <div className="center jumbotron">
            <h1>Welcome to the Sample App</h1>
            <h2>
              This is the home page for the
              <br />
              <a href="https://railstutorial.jp/"> Ruby on Rails Tutorial </a>sample application.
            </h2>
            <Modal title="Sign up!" />
          </div>
        )}
      </Layout>
    </>
  );
}