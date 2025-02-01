# Makefile

push:
	@echo "🚀 Running push.sh..."
	@./shell/push.sh

fork:
	@echo "🚀 Running fork.sh..."
	@./shell/fork.sh

build:
	@echo "🚀 Building project..."
	@bun build bin/main.ts --outfile=public/bin/lokio --compile
	@bun build bin/main.ts --outfile=public/bin/lokio.exe --compile
	@echo "✅ Build completed!"

clean:
	@echo "🧹 Cleaning up..."
	@rm -rf public/bin/lokio public/bin/lokio.exe
	@echo "✅ Clean completed!"

start:
	@public/bin/lokio