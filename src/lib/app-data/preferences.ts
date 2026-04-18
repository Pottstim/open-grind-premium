import z from "zod";
import { existsAppDataFile, readAppDataFile } from ".";
import { decode } from "@msgpack/msgpack";
import { geohashSchema } from "$lib/api/geohash";

const preferencesSchema = z.object({
	geohash: geohashSchema.nullable(),
});

export async function getPreferences(): Promise<
	z.infer<typeof preferencesSchema>
> {
	if (await existsAppDataFile("preferences.data")) {
		return await readAppDataFile("preferences.data")
			.then(decode)
			.then((data) => preferencesSchema.parse(data));
	} else {
		return {
			geohash: null,
		};
	}
}
