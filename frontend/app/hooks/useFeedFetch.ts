// import { Dispatch, SetStateAction, useState } from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';
//Atom
import { FeedStatusAtom, FeedContentAtom, FeedUrlSelector, FeedReloadUrlSelector, FeedContentType } from '../Atoms/FeedAtom';
//Module
import { Auth } from '../modules/Auth';

type useFeedFetchType = {
  handleFetching(): Promise<void>,
  reloadFetching(): Promise<void>,
  isHavingPosts(): boolean
}

export const useFeedFetch = (): useFeedFetchType => {
  //FeedのAtomを呼び出し
  const [FeedStatus, setFeedStatus] = useRecoilState(FeedStatusAtom)
  const [FeedContent, setFeedContent] = useRecoilState(FeedContentAtom)
  const SelectoredFeedUrl = useRecoilValue(FeedUrlSelector)
  const SelectoredFeedReloadUrl = useRecoilValue(FeedReloadUrlSelector)

  async function fetchFeedContents(url: string): Promise<FeedContentType> {
    // console.log({ url })
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${Auth.getToken()}`,
        'Content-Type': 'application/json'
      }
    });
    const json = await response.json()
    // console.log({ json })
    return json
  }

  const handleFetching = async () => {
    const result = await fetchFeedContents(SelectoredFeedUrl)
    // console.log({ result })
    //resultに配列がなければ、FinishLoadingをtrueにする
    if (result.posts.length === 0) {
      setFeedStatus({ ...FeedStatus, FinishLoading: true })
      return
    }

    // Statusの長さが1以上の場合、新しいnewResultを設定して追加
    if (FeedContent && FeedStatus.length != 0) {
      const newResult = { posts: FeedContent.posts.concat(result.posts) }
      // console.log({ newResult })
      setFeedContent(newResult)
      setFeedStatus({ ...FeedStatus, length: newResult.posts.length, })
    } else {
      // Statusの長さが0の場合、直接resultを追加
      setFeedContent(result)
      setFeedStatus({ ...FeedStatus, length: result.posts.length })
    }
  }

  const reloadFetching = async () => {
    const result = await fetchFeedContents(SelectoredFeedReloadUrl)
    setFeedContent(result)
    setFeedStatus({ ...FeedStatus, length: result.posts.length })
  }

  const isHavingPosts = (): boolean => {
    if (FeedContent) {
      return FeedContent.hasOwnProperty("posts")
    }
    return false
  }

  return {
    handleFetching, reloadFetching, isHavingPosts
  }
}