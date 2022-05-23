import Link from "next/link";
//Component
import { PostCard } from "../post/PostCard";
//types
import { PostType } from "../../types/Post";

type PostListProps = {
  posts: PostType[];
  gravator_url: string;
  name: string;
  currentPage: number;
  maxPerPage: number;
  count: boolean;
};

export const UserPostList: React.FC<PostListProps> = ({
  posts,
  gravator_url,
  name,
  currentPage,
  maxPerPage,
  count,
}) => {
  //postの個数を計算
  const count_Posts = (): number => {
    if (posts) {
      return posts.length;
    } else {
      return 0;
    }
  };

  //Paginationの開始と終了時点を計算する
  const start_index = (currentPage - 1) * maxPerPage;
  const end_index = start_index + maxPerPage;

  return (
    <section>
      {count && <h3>Posts ({count_Posts()})</h3>}
      <ul className="posts">
        {posts.slice(start_index, end_index).map((post) => (
          <li key={post.id} id={`post-${post.id}`}>
            <PostCard post={post} gravator_url={gravator_url} name={name} />
          </li>
        ))}
      </ul>
    </section>
  );
};