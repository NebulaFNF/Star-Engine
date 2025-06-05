package funkin.backend.memory;

class Memory
{
	inline public static function getMemory():Float
	{
		#if cpp
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
		#elseif hl
		return hl.Gc.stats().currentMemory;
		#else
		return cast(openfl.system.System.totalMemory, UInt);
		#end
	}

	public static function buildGCInfo():String
	{
		#if cpp
		var result:String = 'HXCPP-Immix:';
		result += '\n- Memory Used: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE)} bytes';
		result += '\n- Memory Reserved: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVED)} bytes';
		result += '\n- Memory Current Pool: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_CURRENT)} bytes';
		result += '\n- Memory Large Pool: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_LARGE)} bytes';
		result += '\n- HXCPP Debugger: ${#if HXCPP_DEBUGGER 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Exp Generational Mode: ${#if HXCPP_GC_GENERATIONAL 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_MOVING 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_DYNAMIC_SIZE 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_BIG_BLOCKS 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Debug Link: ${#if HXCPP_DEBUG_LINK 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Stack Trace: ${#if HXCPP_STACK_TRACE 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Stack Trace Line Numbers: ${#if HXCPP_STACK_LINE 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Pointer Validation: ${#if HXCPP_CHECK_POINTER 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Profiler: ${#if HXCPP_PROFILER 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP Local Telemetry: ${#if HXCPP_TELEMETRY 'Enabled' #else 'Disabled' #end}';
		result += '\n- HXCPP C++11: ${#if HXCPP_CPP11 'Enabled' #else 'Disabled' #end}';
		result += '\n- Source Annotation: ${#if annotate_source 'Enabled' #else 'Disabled' #end}';
		#elseif js
		var result:String = 'JS-MNS:';
		result += '\n- Memory Used: ${getMemoryUsed()} bytes';
		#else
		var result:String = 'Unknown GC';
		#end

		return result;
	}
}
