import { Command } from "commander";
import { CONTEXT_KEY } from "./configs/context-key";
import { clearContext, setContext } from "./context/main";
import { TEXT } from "./environment/text";
import { useReadConfig } from "./hooks/use_config";
import { ProgramCreate } from "./programs/create";
import { ProgramInfo } from "./programs/info";
import { ProgramInit } from "./programs/init";
import { ProgramMake } from "./programs/make";

export const run = async () => {
	try {
		const program = new Command();
		const { exist, data } = useReadConfig();
		await ProgramInit(program, exist);
		if (!exist) {
			clearContext();
			await ProgramCreate(program);
		}
		if (exist) {
			setContext(CONTEXT_KEY.CONFIGS.NAME, data.name);
			setContext(CONTEXT_KEY.CONFIGS.PACKAGE, data.package);
			setContext(CONTEXT_KEY.CONFIGS.DIR, data.dir);
			await ProgramMake(program);
		}

		await ProgramInfo(program);
		// **Tangani error jika command tidak ditemukan**
		program.exitOverride((err) => {
			if (err.code === "commander.unknownCommand") {
				console.error("❌ Salah woy! Perintah tidak ditemukan.\n");
				program.help(); // Tampilkan daftar perintah yang tersedia
			}
		});
		program.parse(process.argv);
	} catch (error) {
		console.error(`${TEXT.PROGRAM.ERROR_RUN}:`, error);
	}
};
