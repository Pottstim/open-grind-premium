import type z from "zod";
import { gendersSchema } from "$lib/model/genders";
import { fetchRest } from "$lib/api";

let cachedGenders: z.infer<typeof gendersSchema> | null = null;
export async function getGenders() {
	if (cachedGenders) return cachedGenders;
	const genders = await fetchRest("/public/v2/genders")
		.then((data) => data.json())
		.then((data) => gendersSchema.parse(data));
	cachedGenders = genders;
	return genders;
}
