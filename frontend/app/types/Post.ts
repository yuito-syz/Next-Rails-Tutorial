export type PostType = {
    id: number,
    content: string,
    user_id: number,
    created_at: string,
    updated_at?: string,
    name?: string,
    image_url?: string
}