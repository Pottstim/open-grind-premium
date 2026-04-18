import { BaseDirectory, open, exists } from "@tauri-apps/plugin-fs";

export async function existsAppDataFile(path: string) {
	return await exists(path, { baseDir: BaseDirectory.AppData });
}

export async function readAppDataFile(path: string) {
	const handle = await open(path, {
		read: true,
		write: false,
		baseDir: BaseDirectory.AppData,
	});
	try {
		const { size } = await handle.stat();
		const buf = new Uint8Array(size);
		handle.read(buf);
		return buf;
	} finally {
		await handle.close();
	}
}

export async function writeAppDataFile(path: string, content: Uint8Array) {
	const handle = await open(path, {
		read: true,
		write: true,
		baseDir: BaseDirectory.AppData,
	});
	try {
		await handle.write(content);
	} finally {
		await handle.close();
	}
}
