#pragma once

#include <string>
#include <vector>
#include <unordered_map>
#include <exception>
#include <sol/sol.hpp>

#include "GameEngine.h"
 
class LuaBinder {
public:
	LuaBinder();
	   
	void Initialize();
	void Start();
	void KeyboardUpdate() const; 
	void Update(float elapsedSec); 
	void Draw() const; 
	 
	void Bind(GameEngine* GameEngine); 
	bool LoadScript(const std::string& scriptName); 
	bool LoadScripts(const std::vector<std::string>& scripts);
	 
	sol::state& GetState() { return m_State; }; 
	bool IsLoaded() const { return m_Loaded; };
private:
	void BindClasses();
	void BindEngineFunctions(GameEngine* GameEngine);  

	bool m_Loaded;
	sol::state m_State;
	std::vector< std::unique_ptr<Bitmap> > m_Textures;
	//std::vector< std::unique_ptr<Audio> > m_Sounds;
};     