import z from "zod";
import { fetchRest } from "$lib/api";
import {
	albumContentSchema,
	albumDetailsSchema,
	albumMinSchema,
} from "$lib/model/album";

export async function getAlbumContent(albumId: number) {
	return await fetchRest(`/v2/albums/${albumId}`)
		.then((res) => res.json())
		.then((res) =>
			z
				.object({
					...albumMinSchema.shape,
					...albumDetailsSchema.shape,
					content: z.array(
						z.object({
							...albumContentSchema.shape,
							remainingViews: z.number().int().optional(),
						}),
					),
				})
				.parse(res),
		);
}

export type AlbumContentResponse = Awaited<ReturnType<typeof getAlbumContent>>;
