import z from "zod";
import { fetchRest } from "$lib/api";
import { profileSchema, type Profile } from "$lib/model/profile";

const profilesCache = new Map<
	number,
	{ profile: Profile; updatedAt: number }
>();
export async function getProfile(profileId: number) {
	const cached = profilesCache.get(profileId);
	if (cached && Date.now() - cached.updatedAt < 1000 * 60) {
		return cached.profile;
	}
	const profile = await fetchRest("/v7/profiles/" + profileId, {
		method: "GET",
	})
		.then((res) => res.json())
		.then(
			(res) =>
				z.object({ profiles: z.array(profileSchema).length(1) }).parse(res)
					.profiles[0],
		);
	profilesCache.set(profileId, { profile, updatedAt: Date.now() });
	return profile;
}
