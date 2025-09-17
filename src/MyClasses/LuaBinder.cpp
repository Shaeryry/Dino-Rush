#include <iostream>
#include "LuaBinder.h"

LuaBinder::LuaBinder() :
	m_Loaded{ false }
{
	m_State.open_libraries(sol::lib::base, sol::lib::math, sol::lib::string, sol::lib::table,sol::lib::package,sol::lib::io);
}

void LuaBinder::Initialize()
{  
	try {	 
		m_State["initialize"]();
	}
	catch (const sol::error& e) { 
		std::cerr << "lua error :" << e.what() << std::endl;
	}
}

void LuaBinder::Start()
{
	try {
		m_State["start"]();
	}
	catch (const sol::error& e) {
		std::cerr << "lua error :" << e.what() << std::endl;
	}
}

void LuaBinder::KeyboardUpdate() const
{
	try {
		m_State["keyboardUpdate"]();
	} 
	catch (const sol::error& e) {
		std::cerr << "lua error :" << e.what() << std::endl;
	}
} 

void LuaBinder::Update(float elapsedSec)
{
	try {
		m_State["update"](elapsedSec);
	}
	catch (const sol::error& e) { 
		std::cerr << "lua error :" << e.what() << std::endl;
	} 
}

void LuaBinder::Draw() const
{
	try {
		m_State["draw"]();
	}
	catch (const sol::error& e) {
		std::cerr << "lua error :" << e.what() << std::endl;
		//GAME_ENGINE->MessageBox(L"oops error");
		//GAME_ENGINE->Quit();
	}
}

void LuaBinder::Bind(GameEngine* GameEngine)
{
	BindClasses();
	BindEngineFunctions(GameEngine);
}

bool LuaBinder::LoadScript(const std::string& scriptName) 
{
	// TODO : add path stuff
	const std::string luaFilesPath{ "lua/" };  
	const std::string filePath{ luaFilesPath + scriptName.c_str() };

	try {
		auto success{ m_State.script_file(filePath) }; 
		return success.valid(); 
	}
	catch (const sol::error& e) {
		std::cerr << "Lua Script" << e.what() << std::endl; 
	}  

	return false; 
} 

bool LuaBinder::LoadScripts(const std::vector<std::string>& scripts)
{
	const size_t SCRIPT_COUNT{ scripts.size() }; 
	int scriptsLoaded{ 0 }; 

	for (const std::string& scriptName : scripts) {
		bool loadedScript{ LoadScript(scriptName) };
		if (loadedScript) scriptsLoaded++;
	}

	return scriptsLoaded >= scripts.size(); 
}
 
void LuaBinder::BindClasses()  
{
	// Export types
	m_State.new_usertype<RECT>("RECT",
		// Constructor  
		sol::constructors<RECT()>(),  

		// Methods  
		"left", &RECT::left, 
		"top", &RECT::top,   
		"right", &RECT::right, 
		"bottom", &RECT::bottom  
	);  

	m_State.new_usertype<Audio>("Audio",
		// Constructor   
		sol::constructors<Audio(std::wstring)>(),
		 
		// Methods 
		"play", &Audio::Play,
		"stop", &Audio::Stop,
		"tick", &Audio::Tick,
		"setRepeat", &Audio::SetRepeat,
		"setVolume", &Audio::SetVolume, 
		"getVolume", &Audio::GetVolume,
		"isPlaying", &Audio::IsPlaying 
	);

}

void LuaBinder::BindEngineFunctions(GameEngine* GameEngine) 
{ 
	// Methods  
	 
	m_State.set_function("setWindowTitle", [](const std::string& title)  
		{
			const std::wstring wTitle{ title.begin(), title.end() };
			GAME_ENGINE->SetTitle(wTitle);
		}
	);

	m_State.set_function("setWindowSize", [](int width, int height)
		{ 
			GAME_ENGINE->SetWidth(width);
			GAME_ENGINE->SetHeight(height);
		}
	); 
	 
	m_State.set_function("isKeyDown", [](const std::string& keyPressed)
		{
			const char* key{ keyPressed.c_str() };
			const bool pressed{ GAME_ENGINE->IsKeyDown(wchar_t(key[0])) };
			if (pressed) {
				std::cout << std::endl;
			}
			return pressed;
		} 
	);
	  
	m_State.set_function("createBitmap", [this](const std::string& texturePath) {
			const std::string resourcesPath{ "Resources/Textures/" }; 
			const std::string path{ resourcesPath + texturePath };
			const std::wstring pathName{ path.begin(),path.end() };

			std::unique_ptr<Bitmap> createdBitmap{ std::make_unique<Bitmap>(pathName) };
			Bitmap* bitmapPtr{ createdBitmap.get() };
			m_Textures.emplace_back(std::move(createdBitmap)); 
			  
			return bitmapPtr; 
		}
	);
	 
	// Draw Methods

	// Bitmaps
		m_State.set_function("drawBitmap", [](const Bitmap* bitmap,double left,double top)
			{
				return GAME_ENGINE->DrawBitmap(bitmap, int(left), int(top));
			}  
		);

		m_State.set_function("getBitmapWidth", [](const Bitmap* bitmap)
			{
				return double(bitmap->GetWidth());  
			}
		);  
		 
		m_State.set_function("getBitmapHeight", [](const Bitmap* bitmap)  
			{
				return double(bitmap->GetHeight());
			}
		);
	   
		m_State.set_function("drawBitmapWithSource", [](const Bitmap* bitmap, double left, double top, RECT sourceRect)
			{
				return GAME_ENGINE->DrawBitmap(bitmap, int(left), int(top), sourceRect);
			} 
		); 
	 
		m_State.set_function("drawBitmapDestinationAndSource", [](const Bitmap* bitmap,RECT destinationRect, RECT sourceRect)
			{
				return GAME_ENGINE->DrawBitmap(bitmap, destinationRect, sourceRect);
			}
		);
	// Text 
		m_State.set_function("drawString", [](const std::wstring& text,RECT rect)
			{
				return GAME_ENGINE->DrawString(text,int(rect.left), int(rect.top), int(rect.right), int(rect.bottom));
			}
		);
	// Other 

	m_State.set_function("setColor", [](int r, int g, int b)
		{
			GAME_ENGINE->SetColor(RGB(r, g, b));
		} 
	);

	m_State.set_function("fillRect", [](double left, double top, double right, double bottom) 
		{
			return GAME_ENGINE->FillRect(left, top, right, bottom);
		}
	);	

	m_State.set_function("drawRect", [](double left, double top, double right, double bottom)
		{
			return GAME_ENGINE->DrawRect(left, top, right, bottom); 
		} 
	);

	m_State.set_function("fillWindowRect", [](int r, int g, int b)
		{
			GAME_ENGINE->FillWindowRect(RGB(r, g, b));
		}
	);

}
