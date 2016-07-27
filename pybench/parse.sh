#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

mkdir -p $(dirname $3)

header="benchmark,base_result,lower_is_better,result"
if [ ! -f "$3" ] || ! grep -q "$header" "$3"; then
    echo "$header" | tee "$3"
fi

test_list=('BuiltinFunctionCalls' 'BuiltinMethodLookup' 'CompareFloats' 'CompareFloatsIntegers'
           'CompareIntegers' 'CompareInternedStrings' 'CompareLongs' 'CompareStrings' 'CompareUnicode'
           'ComplexPythonFunctionCalls' 'ConcatStrings' 'ConcatUnicode' 'CreateInstances'
           'CreateNewInstances' 'CreateStringsWithConcat' 'CreateUnicodeWithConcat' 'DictCreation'
           'DictWithFloatKeys' 'DictWithIntegerKeys' 'DictWithStringKeys' 'ForLoops' 'IfThenElse'
           'ListSlicing' 'NestedForLoops' 'NestedListComprehensions' 'NormalClassAttribute'
           'NormalInstanceAttribute' 'PythonFunctionCalls' 'PythonMethodCalls' 'Recursion'
           'SecondImport' 'SecondPackageImport' 'SecondSubmoduleImport' 'SimpleComplexArithmetic'
           'SimpleDictManipulation' 'SimpleFloatArithmetic' 'SimpleIntFloatArithmetic'
           'SimpleIntegerArithmetic' 'SimpleListComprehensions' 'SimpleListManipulation'
           'SimpleLongArithmetic' 'SmallLists' 'SmallTuples' 'SpecialClassAttribute'
           'SpecialInstanceAttribute' 'StringMappings' 'StringPredicates' 'StringSlicing' 'TryExcept'
           'TryFinally' 'TryRaiseExcept' 'TupleSlicing' 'UnicodeMappings' 'UnicodePredicates'
           'UnicodeProperties' 'UnicodeSlicing' 'WithFinally' 'WithRaiseExcept')

for test in "${test_list[@]}"; do
    pattern="^\s*$test:.+?ms\s+\K[\d\.]+"
    
    base_res=`grep -oP "$pattern" "$1"`
    res=`grep -oP "$pattern" "$2"`

    test_name=`echo "$test" | sed "s/[A-Z]/_\l&/g"`
    echo "pybench$test_name,$base_res,True,$res" | tee -a "$3"
done
