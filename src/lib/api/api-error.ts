export class ApiError extends Error {
	readonly request: {
		method: string;
		path: string;
		body?: unknown;
	};
	readonly response: {
		status: number;
		body: string;
	} | null;

	constructor(options: {
		message: string;
		request: { method: string; path: string; body?: unknown };
		response?: { status: number; body: string } | null;
		cause?: unknown;
	}) {
		super(options.message, { cause: options.cause });
		this.name = "ApiError";
		this.request = options.request;
		this.response = options.response ?? null;
	}

	copyableText(): string {
		return JSON.stringify(
			{
				error: this.message,
				request: this.request,
				response: this.response,
			},
			null,
			2,
		);
	}
}
