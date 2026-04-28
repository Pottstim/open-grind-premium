import z from "zod";
import { fetchRest } from "$lib/api";
import { urlSearchParamsCodec } from "$lib/utils";
import { searchProfileSchema, searchQuerySchema } from "$lib/model/grid/search";
import {
	cascadeV3QuerySchema,
	cascadeV3ResponseItemSchema,
} from "$lib/model/grid/cascade";

export async function searchProfiles(query: z.infer<typeof searchQuerySchema>) {
	return await fetchRest(
		"/v7/search?" +
			new URLSearchParams(
				urlSearchParamsCodec(searchQuerySchema).encode(query),
			),
	)
		.then((res) => res.json())
		.then((data) =>
			z
				.object({
					profiles: z.array(searchProfileSchema),
				})
				.parse(data),
		);
}

/**
 * Main endpoint used in the source apk. /v4/cascade is currently feature-flagged, /v7/search is only for profile tags
 */
export async function getV3Cascade(
	query: z.infer<typeof cascadeV3QuerySchema>,
) {
	return await fetchRest(
		"/v3/cascade?" +
			new URLSearchParams(
				urlSearchParamsCodec(cascadeV3QuerySchema).encode(query),
			),
	)
		.then((res) => res.json())
		.then((data) =>
			z
				.object({
					items: z.array(cascadeV3ResponseItemSchema),
					nextPage: z.number().int().nonnegative(),
					shuffled: z.boolean(),
					hiddenProfiles: z.unknown(),
					hiddenProfileInfo: z.unknown(),
				})
				.parse(data),
		);
}
